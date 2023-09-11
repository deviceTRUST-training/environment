resource "azurerm_network_interface" "vm_byod" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${format("%02d", count.index + 1)}_vm_byod_nic"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  tags                = "${var.tags}"
  dns_servers         = [azurerm_network_interface.vm_dc.private_ip_address]
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${format("%02d", count.index + 1)}_configuration"
    subnet_id                     = "${element(azurerm_subnet.member.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.10.${var.vm.ip_byod + (count.index * 10)}"
  }
}