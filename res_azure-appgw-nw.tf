resource "azurerm_public_ip" "app-gw" {
  name                = "appgw-pip"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method   = "Dynamic"
}