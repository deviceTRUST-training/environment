#!/bin/bash
ansible-galaxy role install -v -r requirements.yml -p roles/
ansible-playbook -i inventory env-guacamole.yml -vvvv