locals {

  custom_data_content_dc = "${file("./files/ConfigureRemotingForAnsible.bat")}"
    
}

resource "azurerm_windows_virtual_machine" "vm_dc" {
  name                  = "${var.azure-environment.prefix}_vm_dc"
  location              = azurerm_resource_group.training.location
  resource_group_name   = azurerm_resource_group.training.name
  network_interface_ids = [azurerm_network_interface.vm_dc.id]
  size               = "Standard_B1ms"  # 1x CPU, 2GB RAM

  computer_name       = "dc"
  admin_username      = var.vm.username
  admin_password      = var.vm.password

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine. This may not be optimal in all cases.
  # delete_os_disk_on_termination = true
  # delete_data_disks_on_termination = true

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  os_disk {
    name              = "${var.azure-environment.prefix}_vm_dc_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

#  os_profile {
#    custom_data    = "${local.custom_data_content_rdsh}"
#  }

  provision_vm_agent        = true
  enable_automatic_upgrades = true

  # Auto-Login's required to configure WinRM
  additional_unattend_content {
    # pass         = "oobeSystem"
    component    = "Microsoft-Windows-Shell-Setup"
    setting = "AutoLogon"
    content      = "<AutoLogon><Password><Value>${var.vm.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.vm.username}</Username></AutoLogon>"
  }

  # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
  additional_unattend_content {
    # pass         = "oobeSystem"
    component    = "Microsoft-Windows-Shell-Setup"
    setting = "FirstLogonCommands"
    content      = "${file("./files/FirstLogonCommands.xml")}"
  }

  tags = "${var.tags}"
}