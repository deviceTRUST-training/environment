resource "azurerm_public_ip" "app-gw" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_app-gw_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
}