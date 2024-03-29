locals {
  custom_data_content_client    = "${file("./files/ConfigureRemotingForAnsible.bat")}"
}

resource "azurerm_windows_virtual_machine" "vm_client" {
  count                         = "${var.azure-environment.instance_count}"
  name                          = "${var.azure-environment.prefix}_${format("%02d", count.index + 1)}_vm_client"
  location                      = azurerm_resource_group.training.location
  resource_group_name           = azurerm_resource_group.training.name
  network_interface_ids         = ["${element(azurerm_network_interface.vm_client.*.id, count.index)}"]
  size                          = "Standard_B2s"  # 2x CPU, 4GB RAM

  computer_name                 = "client${format("%02d", count.index + 1)}"
  admin_username                = var.vm.username
  admin_password                = var.vm.password

  winrm_listener {
    protocol                    = "Http"
  }
  
  source_image_reference {
    offer                       = "Windows-10"
    publisher                   = "MicrosoftWindowsDesktop"
    sku                         = "win10-22h2-entn"
    version                     = "latest"
  }
  # az vm image list --location "west europe" --all --publisher "MicrosoftWindowsDesktop" --sku "win10-22h2" --all

  os_disk {
    name                        = "${var.azure-environment.prefix}_${format("%02d", count.index + 1)}_vm_client_osdisk"
    caching                     = "ReadWrite"
    # create_option     = "FromImage"
    storage_account_type        = "StandardSSD_LRS"
  }
  
  provision_vm_agent            = true

  # Auto-Login's required to configure WinRM
  additional_unattend_content {
    setting                     = "AutoLogon"
    content                     = "<AutoLogon><Password><Value>${var.vm.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.vm.username}</Username></AutoLogon>"
  }

  # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
  additional_unattend_content {
    setting                     = "FirstLogonCommands"
    content                     = "${file("./files/FirstLogonCommands.xml")}"
  }

  tags                          = "${var.tags}"  
}