locals {
  computer_name_guac = "guac"  
}

resource "azurerm_linux_virtual_machine" "vm_guacamole" {
  name                                = "${var.azure-environment.prefix}_vm_guacamole"
  location                            = azurerm_resource_group.training.location
  resource_group_name                 = azurerm_resource_group.training.name
  network_interface_ids               = [azurerm_network_interface.vm_guacamole.id]
  size                             = "Standard_B1ms"

  computer_name       = "guac"
  admin_username      = var.vm.username
  admin_password      = var.vm.password

  disable_password_authentication = false

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine. This may not be optimal in all cases.
  # delete_os_disk_on_termination = true
  # delete_data_disks_on_termination = true

  source_image_reference {
    offer = "0001-com-ubuntu-server-jammy"
    publisher = "Canonical"
    sku = "22_04-lts"
    version = "latest"
  }

  # az vm image list --offer "Ubuntu" --sku "23_10" --publisher "canonical" --all

  os_disk {
    name              = "${var.azure-environment.prefix}_vm_guacamole_osdisk"
    caching           = "ReadWrite"
    # create_option     = "FromImage"
    storage_account_type = "Standard_LRS"
  }

 # os_profile_linux_config {
 #   disable_password_authentication = false
 # }

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
      "sleep 5s",
      "sudo apt -y install docker docker-compose git"
    ]
  }

  #provisioner "remote-exec" {
  #  inline = [
  #    "cd /home/localadmin",
  #    "sudo mkdir git",
  #    "cd /home/localadmin/git",
  #    "sudo git clone https://github.com/jansvensen/guacamole.git",
  #    "cd /home/localadmin/git/guacamole",
  #    "sudo docker-compose up -d"
  #  ]
  #}

  tags = "${var.tags}"
}