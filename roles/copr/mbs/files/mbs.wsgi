#!/usr/bin/python2
import logging
import os
import sys

# so that errors are not sent to stdout
logging.basicConfig(stream=sys.stderr)

os.environ["COPRS_ENVIRON_PRODUCTION"] = "1"
sys.path.insert(0, os.path.dirname(__file__))

from module_build_service import app

if app.debug:
    from werkzeug.debug import DebuggedApplication
    app = DebuggedApplication(app, True)

application = app
