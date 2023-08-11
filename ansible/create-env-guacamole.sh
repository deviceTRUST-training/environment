#!/bin/bash
ansible-galaxy role install -v -r requirements.yml -p roles/
ansible-galaxy collection install -v -r requirements.yml
ansible-playbook -i inventory create-env-guacamole.yml