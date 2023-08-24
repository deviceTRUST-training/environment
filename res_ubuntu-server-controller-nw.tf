resource "azurerm_public_ip" "vm_controller" {
  name                 = "${var.azure-environment.prefix}_vm_controller_pip"
  location             = azurerm_resource_group.training.location
  resource_group_name  = azurerm_resource_group.training.name
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-controller"
}

resource "azurerm_network_interface" "vm_controller" {
  name                = "${var.azure-environment.prefix}_vm_controller_nic"
  location            = azurerm_resource_group.training.location
  resource_group_name = azurerm_resource_group.training.name
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_configuration"
    subnet_id                     = azurerm_subnet.infra.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.254.0.${var.vm.ip_controller}"
    public_ip_address_id          = azurerm_public_ip.vm_controller.id
  }
}

resource "azurerm_network_security_group" "vm_controller" {
  name   = "${var.azure-environment.prefix}_controller_nsg"

  resource_group_name   = azurerm_resource_group.training.name
  location              = azurerm_resource_group.training.location

  security_rule {
      name                   = "con_in_ssh_sven"
      priority               = 201
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "92.50.117.117/32"
      destination_address_prefix = "*"
    }
    
    security_rule {
        name                   = "con_in_ssh_hetzner"
        priority               = 202
        direction              = "Inbound"
        access                 = "Allow"
        protocol               = "Tcp"
        source_port_range      = "*"
        destination_port_range = "22"
        source_address_prefix  = "157.90.213.49/32"
        destination_address_prefix = "*"
    }
    security_rule { 
      name                   = "con_in_ssh_sepago"
      priority               = 666
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "87.190.225.226/32"
      destination_address_prefix = "*"
    }
                  security_rule {
      name                   = "con_in_ssh_dthq"
      priority               = 669
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "22"
      source_address_prefix  = "213.188.105.126/32"
      destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface_security_group_association" "vm_controller_infra" {

  network_interface_id      = azurerm_network_interface.vm_controller.id
  network_security_group_id = azurerm_network_security_group.vm_controller.id
  
}