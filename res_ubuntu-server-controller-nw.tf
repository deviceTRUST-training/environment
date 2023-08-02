resource "azurerm_public_ip" "vm_controller" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_${count.index}_vm_controller_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = "${element(azurerm_resource_group.main.*.name, count.index)}"
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-ctrl-${count.index}"
}

resource "azurerm_network_interface" "vm_controller_external" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_external"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.external.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.${count.index}.1.${var.vm.ip_controller}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_controller.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "vm_controller_internal" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_internal"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = "${element(azurerm_resource_group.main.*.name, count.index)}"
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.${count.index}.2.${var.vm.ip_controller}"
  }
}

module "network-security-group" {
  source                = "Azure/network-security-group/azurerm"
  resource_group_name   = "${element(azurerm_resource_group.main.*.name, count.index)}"
  location              = "${element(azurerm_resource_group.main.*.location, count.index)}"
  security_group_name   = "nsg_ssh"
  source_address_prefix = ["92.50.117.117/32"]
  predefined_rules = [
    {
      name     = "SSH"
      priority = "500"
    }
  ]

  custom_rules = [
    {
      name                   = "myssh"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "92.50.117.117/324"
      description            = "description-myssh"
    }
  ]

  depends_on = [azurerm_network_interface.vm_controller_internal]
}