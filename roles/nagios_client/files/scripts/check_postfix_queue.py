#!/usr/bin/python3

import subprocess
import json
import argparse
import sys

from datetime import datetime

parser = argparse.ArgumentParser()
parser.add_argument('domain', help="Required. Domain to check")
parser.add_argument('-c', '--critical', dest='critical', type=int, default=50,
                    help="Critical threshold")
parser.add_argument('-w', '--warning', dest='warning', type=int, default=20,
                    help="Warning threshold")
parser.add_argument('-i', '--ignore', dest='ignore', type=int, default=5,
                    help="Ignore queues from the last X minutes (default: 5)")
args = parser.parse_args()


now = datetime.now()
p = subprocess.Popen(['/usr/sbin/postqueue', '-j'],
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.STDOUT)
output = str(p.stdout.read(), "utf-8").splitlines()
mail_queue = 0


if args.domain == 'all':
  mail_queue = len(output)
else:

  for line in output:
      j = json.loads(line)
      if j["queue_name"] == 'active':
          # Ignore Active queue
          continue

      queue_old = now - datetime.fromtimestamp(j["arrival_time"])
      if queue_old.total_seconds() / 60 < args.ignore:
          # Not old enough
          continue
          
      for recipient in j['recipients']:
          if recipient['address'].endswith(args.domain):
              mail_queue += 1
              break


ret_val = 0
msg = ("OK: Queue length for %s destination < %s (%s)"
      % (args.domain, args.warning, mail_queue))

if mail_queue > args.warning:
    msg = ("WARNING: Queue length for %s destination > %s (%s)"
          % (args.domain, args.warning, mail_queue))
    ret_val = 1

if mail_queue > args.critical:
    msg = ("CRITICAL: Queue length for %s destination > %s (%s)"
          % (args.domain, args.critical, mail_queue))
    ret_val = 2


print(msg)
sys.exit(ret_val)