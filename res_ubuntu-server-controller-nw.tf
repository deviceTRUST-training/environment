locals {
  private_ip_address_internal = "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_controller}"
  private_ip_address_external = "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_controller+1}"
}

resource "azurerm_public_ip" "vm_controller" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_${count.index}_vm_controller_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-ctrl-${count.index}"
}

resource "azurerm_network_interface" "vm_controller_internal" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_internal"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = local.private_ip_address_internal
  }
}

resource "azurerm_network_interface" "vm_controller_external" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_external"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.external.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = local.private_ip_address_external
    public_ip_address_id          = "${element(azurerm_public_ip.vm_controller.*.id, count.index)}"
  }
}