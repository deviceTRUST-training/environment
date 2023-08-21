resource "azurerm_network_interface" "vm_dc_internal" {
  name                = "${var.azure-environment.prefix}_vm_dc_nic_internal"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_configuration"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.0.${var.vm.ip_dc}"
  }
}