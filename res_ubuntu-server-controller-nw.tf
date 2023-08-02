resource "azurerm_public_ip" "vm_controller" {
  count                = "${var.azure-environment.instance_count}"
  name                 = "${var.azure-environment.prefix}_${count.index}_vm_controller_pip"
  location             = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name  = azurerm_resource_group.main.name
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-ctrl-${count.index}"
}

resource "azurerm_network_interface" "vm_controller_external" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_external"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = azurerm_resource_group.main.name
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.external.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.2${count.index}.${var.vm.ip_controller}"
    public_ip_address_id          = "${element(azurerm_public_ip.vm_controller.*.id, count.index)}"
  }
}

resource "azurerm_network_interface" "vm_controller_internal" {
  count               = "${var.azure-environment.instance_count}"
  name                = "${var.azure-environment.prefix}_${count.index}_vm_controller_nic_internal"
  location            = "${element(azurerm_resource_group.main.*.location, count.index)}"
  resource_group_name = azurerm_resource_group.main.name
  tags                = "${var.tags}"
  ip_configuration {
    name                          = "${var.azure-environment.prefix}_${count.index}_configuration"
    subnet_id                     = "${element(azurerm_subnet.internal.*.id, count.index)}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.${count.index}.${var.vm.ip_controller}"
  }
}

resource "azurerm_network_security_group" "vm_controller_external" {
  count                 = "${var.azure-environment.instance_count}"

  resource_group_name   = azurerm_resource_group.main.name
  location              = "${element(azurerm_resource_group.main.*.location, count.index)}"
  name   = "${var.azure-environment.prefix}_${count.index}_nsg_ssh"

  security_rule =  {
      name                   = "in_ssh_sven"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "92.50.117.117/32"
      destination_address_prefix = "*"
      description                   = "in_ssh_sven"
  }

  custom_rules =  {
      name                   = "in_ssh_hetzner"
      priority               = 202
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "157.90.213.49/32"
      destination_address_prefix = "*"
      description                   = "in_ssh_hetzner"
  }

}

resource "azurerm_network_interface_security_group_association" "vm_controller_external" {
  count                 = "${var.azure-environment.instance_count}"

  network_interface_id      = "${element(azurerm_network_interface.vm_controller_external.*.id, count.index)}"
  network_security_group_id = "${element(azurerm_network_security_group.vm_controller_external.*.id, count.index)}"
  
}
