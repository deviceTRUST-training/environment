locals {
  computer_name = "guac"  
}

resource "azurerm_virtual_machine" "vm_guacamole" {
  name                                = "${var.azure-environment.prefix}_vm_guacamole"
  location                            = azurerm_resource_group.main.location
  resource_group_name                 = azurerm_resource_group.main.name
  primary_network_interface_id        = azurerm_network_interface.vm_guacamole_external.id
  network_interface_ids               = [azurerm_network_interface.vm_guacamole_external.id,azurerm_network_interface.vm_guacamole_internal.id]
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
    name              = "${var.azure-environment.prefix}_vm_guacamole_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name}"
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

  provisioner "remote-exec" {
    inline = [
      "sleep 5s",
      "sudo apt -y update",
      "sleep 5s"
    ]
  }

  tags = "${var.tags}"
}