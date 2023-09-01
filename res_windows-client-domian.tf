locals {
  computer_name_client = "client-01"
  custom_data_content_client = "${file("./files/ConfigureRemotingForAnsible.bat")}"
    
}

resource "azurerm_virtual_machine" "vm_client" {
  count                 = "${var.azure-environment.instance_count}"
  name                  = "${var.azure-environment.prefix}_${count.index}_vm_client"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  network_interface_ids = ["${element(azurerm_network_interface.vm_client.*.id, count.index)}"]
  vm_size               = "Standard_B2s"  # 2x CPU, 4GB RAM

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine. This may not be optimal in all cases.
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true
  
  storage_image_reference {
    offer = "Windows-10"
    publisher = "MicrosoftWindowsDesktop"
    sku = "win10-22h2-entn"
    version = "latest"
  }
  # az vm image list --location "west europe" --all --publisher "MicrosoftWindowsDesktop" --sku "win10-22h2" --all

  storage_os_disk {
    name              = "${var.azure-environment.prefix}_${count.index}_vm_client_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name_client}"
    admin_username = "${var.vm.username}"
    admin_password = "${var.vm.password}"
    custom_data    = "${local.custom_data_content_client}"
  }
  
  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${var.vm.password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.vm.username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("./files/FirstLogonCommands.xml")}"
    }
  }

  tags = "${var.tags}"
}