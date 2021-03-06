#!/bin/bash

openstack overcloud deploy --templates \
  -e /home/stack/templates/node-info.yaml\
  -e /home/stack/templates/overcloud_images.yaml \
  -r /home/stack/templates/roles_data.yaml \
  --ntp-server cloud-noc01.cloud.fedoraproject.org \
  --config-download \
  -e /usr/share/openstack-tripleo-heat-templates/environments/config-download-environment.yaml \
  --overcloud-ssh-user heat-admin \
  --overcloud-ssh-key ~/.ssh/id_rsa \
  -e /home/stack/templates/cinder-dellps-config.yaml \
  -e /home/stack/templates/rhel-registration/environment-rhel-registration.yaml
