resource "azurerm_public_ip" "vm_controller" {
  count                = "${var.azure-environment.instance_count}"
  # name                 = "${var.azure-environment.prefix}_vm_controller_pip"
  name                 = "${var.azure-environment.prefix}_${var.azure-environment.instance_count}_vm_controller_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-ctrl-${count.index}"
}

resource "azurerm_network_interface" "vm_controller" {
  count               = "${var.azure-environment.instance_count}"
  # name                = "${var.azure-environment.prefix}_vm_controller_nic"
  name                = "${var.azure-environment.prefix}_${var.azure-environment.instance_count}_vm_controller_nic"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"

  ip_configuration {
    # name                          = "${var.azure-environment.prefix}_configuration"
    name                          = "${var.azure-environment.prefix}_${var.azure-environment.instance_count}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    # private_ip_address            = "${cidrhost("10.10.11.0/24", 91)}"
    private_ip_address            = "${var.azure-environment.ip_prefix}${var.azure-environment.instance_count}.${var.vm.ip_controller}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_controller.*.id, count.index)}"
  }
}