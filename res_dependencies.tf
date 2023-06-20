resource "azurerm_resource_group" "main" {
  count    = "${var.azure-environment.instance_count}"
  name     = "${var.azure-environment.prefix}_resources_${count.index}"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "main" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_main${count.index}"
  address_space       = ["10.${count.index}.0.0/16"]
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  # dns_servers         = [ "10.${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "external" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "external"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["10.${count.index}.1.0/24"]
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["10.${count.index}.2.0/24"]
}