#!/bin/sh
ansible-playbook -i dev \
    --private-key ~/.vagrant.d/insecure_private_key deploy/recreate_db.yml
