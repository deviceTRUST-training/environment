locals {
  computer_name_guacamole = "guacamole"  
}

resource "azurerm_virtual_machine" "vm_guacamole" {
  name                  = "${var.azure-environment.prefix}_vm_guacamole"
  location              = "${element(azurerm_resource_group.main.*.location, count.index)}" # ToDo
  resource_group_name   = "${element(azurerm_resource_group.main.*.name, count.index)}" # ToDo
  network_interface_ids = ["${element(azurerm_network_interface.vm_guacamole.*.id, count.index)}"] # ToDo
  vm_size               = "Standard_B1ms"

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    offer = "0001-com-ubuntu-server-kinetic"
    publisher = "Canonical"
    sku = "22_10"
    version = "22.10.202210220"
  }
  # aaz vm image list --offer "Ubuntu" --sku "22_10" --publisher "canonical" --all

  storage_os_disk {
    name              = "${var.azure-environment.prefix}_vm_guacamole_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name_guacamole}"
    admin_username = "${var.vm.username}"
    admin_password = "${var.vm.password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  connection {
      host = azurerm_public_ip.vm_guacamole.ip_address
      type = "ssh"
      user = "${var.vm.username}"
      password = "${var.vm.password}"
  }

  depends_on = [azurerm_virtual_machine.vm_dc, azurerm_virtual_machine.vm_rdsh, azurerm_virtual_machine.vm_client, azurerm_virtual_machine.vm_byod]

  tags = "${var.tags}"
}