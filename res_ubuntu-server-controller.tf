locals {
  computer_name_ctrl = "ctrl"  
}

resource "azurerm_virtual_machine" "vm_controller" {
  name                                = "${var.azure-environment.prefix}_vm_controller"
  location                            = azurerm_resource_group.main.location
  resource_group_name                 = azurerm_resource_group.main.name
  network_interface_ids               = [azurerm_network_interface.vm_controller.id]
  vm_size                             = "Standard_B1ms"

  delete_os_disk_on_termination       = true
  delete_data_disks_on_termination    = true

  storage_image_reference {
    offer = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku = "22_04-lts"
    version = "latest"
  }

  # az vm image list --offer "Ubuntu" --sku "23_10" --publisher "canonical" --all

  storage_os_disk {
    name              = "${var.azure-environment.prefix}_vm_controller_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name_guac}"
    admin_username = "${var.vm.username}"
    admin_password = "${var.vm.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  connection {
      host = azurerm_public_ip.vm_controller.ip_address
      type = "ssh"
      user = "${var.vm.username}"
      password = "${var.vm.password}"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 5s",
      "sudo apt install -y unzip ansible sshpass",
      "sleep 5s"
    ]
  }

  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-galaxy collection install microsoft.ad",
      "ansible-galaxy collection install ansible.windows",  # up to be deprecated
      "ansible-galaxy collection install community.windows" # up to be deprecated
    ]
  }

#  provisioner "remote-exec" {
#    inline = [
#      "cd /tmp",
#      "cd /tmp/ansible",
#      "ansible-galaxy install -v -r requirements.yml -p ./roles/",
#      "ansible-playbook -i inventory site.yml --extra-vars 'ansible_user=${var.vm.username} ansible_password=${var.vm.password} domain_admin_user=${var.vm.username}@${var.vm.domain_dns_name} domain_admin_password=${var.vm.password} safe_mode_password=${var.vm.password}'",
#    ]
#  }

  # depends_on = [azurerm_virtual_machine.vm_dc, azurerm_virtual_machine.vm_rdsh, azurerm_virtual_machine.vm_client, azurerm_virtual_machine.vm_byod]
  depends_on = [azurerm_virtual_machine.vm_dc]

  tags = "${var.tags}"
}
  