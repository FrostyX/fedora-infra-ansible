"""
This script runs in a loop and clone or update the clone of the ansible repo
hosted in pagure.io
"""
from __future__ import print_function

import datetime
import logging
import os
import sched
import subprocess
import sys
import time

from fedora_messaging import api, config


_log = logging.getLogger(__name__)


def run_command(command, cwd=None):
    """ Run the specified command in a specific working directory if one
    is specified.

    :arg command: the command to run
    :type command: list
    :kwarg cwd: the working directory in which to run this command
    :type cwd: str or None
    """
    output = None
    try:
        output = subprocess.check_output(command, cwd=cwd, stderr=subprocess.PIPE)
    except subprocess.CalledProcessError as e:
        _log.error("Command `%s` return code: `%s`", " ".join(command), e.returncode)
        _log.error("stdout:\n-------\n%s", e.stdout)
        _log.error("stderr:\n-------\n%s", e.stderr)
        raise

    return output


class MirrorFromPagure(object):
    """
    A fedora-messaging consumer update a local mirror of a repo hosted on
    pagure.io.

    Three configuration key is used from fedora-messaging's
    "consumer_config" key:
     - "mirror_folder", which indicates where mirrors should be store
     - "urls", which is a list of mirrors to keep up to date
     - "triggers_name", the fullname of the project (ie: name or namespace/name)
       that we want to trigger a refresh of our clone on

     ::

        [consumer_config]
        mirror_folder = "mirrors"
        trigger_names = ["Fedora-Infra/ansible"]
        urls = ["https://pagure.io/Fedora-Infra/ansible.git"]
    """

    def __init__(self):
        """Perform some one-time initialization for the consumer."""
        self.path = config.conf["consumer_config"]["mirror_folder"]
        self.urls = config.conf["consumer_config"]["urls"]
        self.trigger_names = config.conf["consumer_config"]["trigger_names"]

        if not os.path.exists(self.path):
            raise OSError("No folder %s found on disk" % self.path)

        _log.info("Ready to consume and trigger on %s", self.trigger_names)

    def __call__(self, message, cnt=0):
        """
        Invoked when a message is received by the consumer.

        Args:
            message (fedora_messaging.api.Message): The message from AMQP.
        """
        _log.info("Received topic: %s", message.topic)
        if message.topic == "io.pagure.prod.pagure.git.receive":
            repo_name = message.body.get("repo", {}).get("fullname")
            if repo_name not in self.trigger_names:
                _log.info("%s is not a pagure repo of interest, bailing", repo_name)
                return
        else:
            _log.info("Unexpected topic received: %s", message.topic)
            return

        try:
            for url in self.urls:
                _log.info("Syncing %s", url)
                name = url.rsplit("/", 1)[-1]

                dest_folder = os.path.join(self.path, name)
                if not os.path.exists(dest_folder):
                    _log.info("   Cloning as new %s", url)
                    cmd = ["git", "clone", "--mirror", url]
                    run_command(cmd, cwd=self.path)

                _log.info(
                    "   Running git fetch with transfer.fsckObjects=1 in %s",
                    dest_folder,
                )
                cmd = ["git", "-c", "transfer.fsckObjects=1", "fetch"]
                run_command(cmd, cwd=dest_folder)

        except Exception:
            _log.exception("Something happened while calling git")
            if cnt >= 3:
                raise
            _log.info("  Re-running in 10 seconds")
            time.sleep(10)
            self.__call__(message, cnt=cnt + 1)
