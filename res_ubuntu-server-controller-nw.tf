resource "azurerm_public_ip" "vm_controller" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_${count.index}_vm_controller_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-ctrl-${count.index}"
}

resource "azurerm_network_interface" "vm_controller_main" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_main"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  primary             = true

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.main.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.azure-environment.ip_prefix}${count.index}.${var.vm.ip_controller}"
  }
}

resource "azurerm_network_interface" "vm_controller_infrastructure" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_infrastructure"
  location            = azurerm_resource_group.infrastructure.location
  resource_group_name = azurerm_resource_group.infrastructure.name
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = azurerm_subnet.infrastructure.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.azure-environment.ip_prefix}100.1${count.index}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_controller.*.id, count.index)}"
  }
}