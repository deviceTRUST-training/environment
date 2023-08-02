resource "azurerm_public_ip" "vm_guacamole" {
  name                 = "${var.azure-environment.prefix}_vm_guacamole_pip"
  location             = azurerm_resource_group.main.location
  resource_group_name  = azurerm_resource_group.main.name
  allocation_method    = "Static"
  tags                 = "${var.tags}"
  domain_name_label    = "${var.azure-environment.prefix}-guac"
}

resource "azurerm_network_interface" "vm_guacamole" {
  name                = "${var.azure-environment.prefix}_vm_guacamole_nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = "${var.tags}"

  ip_configuration {
    name                          = "${var.azure-environment.prefix}_configuration"
    subnet_id                     = azurerm_subnet.guac.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.10.254.${var.vm.ip_guacamole}"
    public_ip_address_id          = azurerm_public_ip.vm_guacamole.id
  }
}

resource "azurerm_network_security_group" "vm_guacamole" {
  name   = "${var.azure-environment.prefix}_nsg_ssh"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location

  security_rule {
      name                   = "in_ssh_sven"
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
        name                   = "in_ssh_hetzner"
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
      name                   = "in_https_sven"
      priority               = 211
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "443"
      source_address_prefix  = "92.50.117.117/32"
      destination_address_prefix = "*"
    }
    
  security_rule {
      name                   = "in_http_sven"
      priority               = 212
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "80"
      source_address_prefix  = "92.50.117.117/32"
      destination_address_prefix = "*"
    }
   security_rule {
      name                   = "in_guacamole_sven"
      priority               = 212
      direction              = "Inbound"
      access                 = "Allow"
      protocol               = "Tcp"
      source_port_range      = "*"
      destination_port_range = "8080"
      source_address_prefix  = "92.50.117.117/32"
      destination_address_prefix = "*"
    }   
}

resource "azurerm_network_interface_security_group_association" "vm_guacamole_external" {

  network_interface_id      = azurerm_network_interface.vm_guacamole.id
  network_security_group_id = azurerm_network_security_group.vm_guacamole.id
  
}
