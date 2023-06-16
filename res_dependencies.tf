resource "azurerm_resource_group" "main" {
  count    = "${var.azure-environment.instance_count}"
  name     = "${var.azure-environment.prefix}_resources_${count.index}"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "external" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_external${count.index}"
  address_space       = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  # dns_servers         = [ "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "external" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "external"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
}

resource "azurerm_virtual_network" "internal" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_internal${count.index}"
  address_space       = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  # dns_servers         = [ "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
}