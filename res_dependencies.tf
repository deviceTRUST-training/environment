resource "azurerm_resource_group" "main" {
  count    = "${var.azure-environment.instance_count}"
  name     = "${var.azure-environment.prefix}_resources_${count.index}"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "internal" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_${count.index}"
  address_space       = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
  location            = "${element(azurerm_resource_group.internal.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.internal.*.name, count.index)}"
  tags                = "${var.tags}"
  dns_servers         = [ "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "${element(azurerm_resource_group.internal.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.internal.*.name, count.index)}"
  address_prefixes     = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
}

resource "azurerm_virtual_network" "external" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_${count.index}"
  # address_space       = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
  location            = "${element(azurerm_resource_group.external.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.external.*.name, count.index)}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "external" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "${element(azurerm_resource_group.external.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.external.*.name, count.index)}"
  # address_prefixes     = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
}