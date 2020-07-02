#!/usr/bin/python
#
# very simple python script to parse out /proc/mdstat
# and give results for nagios to monitor
#

import sys

devices = []

try:
    mdstat = open('/proc/mdstat').read().split('\n')
except IOError:
    # seems we have no software raid on this machines
    sys.exit(0)

error = ""
i = 0
for line in mdstat:
    if line[0:2] == 'md':
        device = line.split()[0]
        devices.append(device)
        status = mdstat[i+1].split()[-1]
        if status.count("_"):
            # see if we can figure out what's going on
            err = mdstat[i+2].split()
            msg = "device=%s status=%s" % (device, status)
            if len(err) > 0:
                msg = msg + " rebuild=%s" % err[0]

            if not error:
                error = msg
            else:
                error = error + ", " + msg
    i = i + 1

if not error:
    print("DEVICES %s OK" % " ".join(devices))
    sys.exit(0)

else:
    print(error)
    sys.exit(2)
