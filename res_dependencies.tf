resource "azurerm_resource_group" "training" {
  name     = "${var.azure-environment.prefix}_resources"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "training" {
  name                = "vnet_training"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  tags                = "${var.tags}"
  # dns_servers         = [ "10.${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "external" {
  name                 = "external"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "guac" {
  name                 = "guac"
  resource_group_name  = azurerm_resource_group.training.name
  virtual_network_name = azurerm_virtual_network.training.name
  address_prefixes     = ["10.10.254.0/24"]
}