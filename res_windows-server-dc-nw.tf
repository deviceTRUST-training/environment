resource "azurerm_public_ip" "vm_dc" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_${count.index}_vm_dc_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-dc-${count.index}"
}

resource "azurerm_network_interface" "vm_dc" {
  count                = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_dc_nic"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_dc}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_dc.*.id, count.index)}"
  }
}