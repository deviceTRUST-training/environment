resource "azurerm_public_ip" "vm_byod" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_vm_byod_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-byod-${count.index}"
}

resource "azurerm_network_interface" "vm_byod" {
  count                = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_vm_byod_nic"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  applied_dns_servers = ["10.10.11.10"]
  dns_servers         = ["10.10.11.10"]

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${cidrhost("10.10.11.0/24", 13)}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_byod.*.id, count.index)}"
  }
}