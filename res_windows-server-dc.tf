locals {

  computer_name_dc = "dc01"
  custom_data_content_dc = "${file("./files/ConfigureRemotingForAnsible.bat")}"
    
}

resource "azurerm_virtual_machine" "vm_dc" {
  count                 = "${var.azure-environment.instance_count}"
  name                  = "${var.azure-environment.prefix}_vm_dc"
  location              = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name   = "${element(azurerm_resource_group.main.*.name, count.index)}"
  network_interface_ids = ["${element(azurerm_network_interface.vm_dc.*.id, count.index)}"]
  vm_size               = "Standard_B1ms"  # 1x CPU, 2GB RAM

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.azure-environment.prefix}_vm_dc_osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name  = "${local.computer_name_dc}"
    admin_username = "${var.vm.username}"
    admin_password = "${var.vm.password}"
    custom_data    = "${local.custom_data_content_dc}"
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