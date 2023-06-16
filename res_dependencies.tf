# Infrastructure resources

resource "azurerm_resource_group" "infrastructure" {
  name     = "${var.azure-environment.prefix}_infrastructure"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "infrastructure" {
  name                = "${var.azure-environment.prefix}_network_infrastructure"
  address_space       = ["${var.azure-environment.ip_prefix}100.0/24"]
  location            = "azurerm_resource_group.infrastructure.location"
  resource_group_name = "azurerm_resource_group.infrastructure.name"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "azurerm_resource_group.infrastructure.name"
  virtual_network_name = "azurerm_virtual_network.infrastructure.name"
  address_prefixes     = ["${var.azure-environment.ip_prefix}100.0/24"]
}

# VM resources
resource "azurerm_resource_group" "main" {
  count    = "${var.azure-environment.instance_count}"
  name     = "${var.azure-environment.prefix}_resources_${count.index}"
  location = "${var.azure-environment.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "main" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_network_${count.index}"
  address_space       = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  dns_servers         = [ "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_dc}" ]
}

resource "azurerm_subnet" "internal" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "internal"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  virtual_network_name = "${element(azurerm_virtual_network.main.*.name, count.index)}"
  address_prefixes     = ["${var.azure-environment.ip_prefix}${count.index}.0/24"]
}