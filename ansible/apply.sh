cd /tmp/ansible
ansible-galaxy install -v -r requirements.yml -p ./roles/
# ansible-playbook -i inventory site.yml --extra-vars 'ansible_user=${var.vm.username} ansible_password=${var.vm.password} domain_admin_user=${var.vm.username}@${var.vm.domain_dns_name} domain_admin_password=${var.vm.password} safe_mode_password=${var.vm.password}'
ansible-playbook -i inventory site.yml --extra-vars 'ansible_user="localadmin" ansible_password="S00perSecurePassword!" domain_admin_user="localadmin@dt.training" domain_admin_password="S00perSecurePassword!" safe_mode_password="S00perSecurePassword!"'
