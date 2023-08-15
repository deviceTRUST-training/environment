#!/bin/bash
git pull
ansible-galaxy role install -v -r requirements.yml -p roles/
ansible-playbook -i inventory linux-guacamole.yml