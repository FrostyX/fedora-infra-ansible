#!/usr/bin/env python
""" This is a glue script to run /usr/local/bin/owner-sync-pagure on a given
package anytime a ticket gets closed at
https://pagure.io/releng/fedora-scm-requests

Author: Ralph Bean <rbean@redhat.com>
        Pierre-Yves Chibon <pingou@pingoured.fr>
"""

import logging
import json
import subprocess as sp
import sys

from fedora_messaging import config

_log = logging.getLogger("koji_sync_listener")


class KojiSyncListener(object):
    """
    A fedora-messaging consumer that calls the owner-sync-pagure script
    upon notifications coming from pagure.

    A single configuration key is used from fedora-messaging's
    "consumer_config" key, "path", which is where the consumer will save
    the messages::

        [consumer_config]
        path = "/tmp/fedora-messaging/messages.txt"
    """
    def __init__(self):
        """Perform some one-time initialization for the consumer."""
        self.taglist = config.conf["consumer_config"]["taglist"]

    def __call__(self, message):
        """
        Invoked when a message is received by the consumer.

        Args:
            message (fedora_messaging.api.Message): The message from AMQP.
        """
        body = message.body

        fullname = body.get("project", {}).get("fullname")
        fields = body.get("fields")
        content = body.get('issue', {}).get('content')

        if fullname != 'releng/fedora-scm-requests':
            _log.info("Dropping %r.  Not scm request." % fullname)
            return False
        if 'close_status' not in fields:
            _log.info("Dropping %r %r.  Not closed." % (fullname, fields))
            return False

        try:
            body = content.strip('`').strip()
            body = json.loads(body)
        except Exception:
            _log.info("Failed to decode JSON in the issue's initial comment")
            return False

        package = content['repo']
        _log.info("Operating on {package}".format(package=package))
        sys.stdout.flush()

        cmd = [
            '/usr/local/bin/owner-sync-pagure',
            '--package', package,
            '--verbose',
        ] + self.taglist

        _log.info("Running %r" % cmd)
        proc = sp.Popen(cmd)
        status = proc.wait()
        if status:
            raise RuntimeError("%r gave return code %r" % (cmd, status))

        _log.info("Done.")
