resource "azurerm_resource_group" "main" {
  name     = "${var.azure-environment.prefix}_resources"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet_main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = "${var.tags}"
  # dns_servers         = [ "10.${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "external" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "external_${count.index}"
  resource_group_name  = azurerm_resource_group.main.*.name
  virtual_network_name = azurerm_virtual_network.main
  address_prefixes     = ["10.${count.index}.1.0/24"]
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.*.name
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["10.${count.index}.2.0/24"]
}