#!/bin/sh
rm -rf /httpdir/*
mkdir /httpdir/run/ /httpdir/run/ccaches/
ln -s /etc/httpd/modules /httpdir/modules
truncate --size=0 /httpdir/access.log /httpdir/error.log
tail -qf /httpdir/access.log /httpdir/error.log &
exec httpd -f /etc/fasjson/httpd.conf -DFOREGROUND -DNO_DETACH
