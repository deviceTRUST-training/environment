resource "azurerm_public_ip" "vm_guacamole" {
  name                 = "${var.azure-environment.prefix}_vm_guacamole_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}" # ToDo
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}" # ToDo
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-guacamole"
}

resource "azurerm_network_interface" "vm_guacamole" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_guacamole_nic"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"

  ip_configuration {
    # name                          = "${var.azure-environment.prefix}_configuration"
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    # private_ip_address            = "${cidrhost("10.10.11.0/24", 91)}"
    private_ip_address            = "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_guacamole}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_guacamole.*.id, count.index)}"
  }
}