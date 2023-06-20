locals {
  computer_name_ctrl = "ctrl"  
}

resource "azurerm_virtual_machine" "vm_controller" {
  count                               = "${var.azure-environment.instance_count}"
  name                                = "${var.azure-environment.prefix}_${count.index}_vm_controller"
  location                            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name                 = "${element(azurerm_resource_group.main.*.name, count.index)}"
  primary_network_interface_id        = "${element(azurerm_network_interface.vm_controller_external.*.id, count.index)}"
  network_interface_ids               = ["${element(azurerm_network_interface.vm_controller_external.*.id, count.index)}","${element(azurerm_network_interface.vm_controller_internal.*.id, count.index)}"]
  vm_size                             = "Standard_B1ms"

  delete_os_disk_on_termination       = true
  delete_data_disks_on_termination    = true

  storage_image_reference {
    offer = "0001-com-ubuntu-server-kinetic"
    publisher = "Canonical"
    sku = "23_04"
    version = "latest"
  }
  # aaz vm image list --offer "Ubuntu" --sku "22_10" --publisher "canonical" --all

  storage_os_disk {
    name              = "${var.azure-environment.prefix}_${count.index}_vm_controller_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name_ctrl}"
    admin_username = "${var.vm.username}"
    admin_password = "${var.vm.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  connection {
      host = "${element(azurerm_public_ip.vm_controller.*.ip_address, count.index)}"
      type = "ssh"
      user = "${var.vm.username}"
      password = "${var.vm.password}"
  }

  provisioner "file" {
    source = "scripts"
    destination = "/tmp"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod -R +x /tmp/scripts",
      "/tmp/scripts/ansible_apt.sh",
    ]
  }

  provisioner "file" {
    source = "ansible"
    destination = "/tmp"
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

  tags = "${var.tags}"
}