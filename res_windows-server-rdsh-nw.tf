resource "azurerm_network_interface" "vm_rdsh" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_rdsh_nic"
  location            = "${element(azurerm_resource_group.training.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.training.*.name, count.index)}"
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.member.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.10.${var.vm.ip_rdsh * count.index}"
  }
}