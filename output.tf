output "fqdn_vm_controller" {
  value = "${azurerm_public_ip.vm_controller.*.fqdn}"
}
output "private_ip_address_vm_controller" {
  value = "${azurerm_network_interface.vm_controller.*.ip_configuration.private_ip_address}"
}
output "public_ip_address_vm_controller" {
  value = "${azurerm_public_ip.vm_controller.*.ip_address}"
}

output "fqdn_vm_dc" {
  value = "${azurerm_public_ip.vm_dc.*.fqdn}"
}
output "private_ip_address_vm_dc" {
  value = "${azurerm_network_interface.vm_dc.*.ip_configuration.private_ip_address}"
}
output "public_ip_address_vm_dc" {
  value = "${azurerm_public_ip.vm_dc.*.ip_address}"
}

output "fqdn_vm_client" {
  value = "${azurerm_public_ip.vm_client.*.fqdn}"
}
output "private_ip_address_vm_client" {
  value = "${azurerm_network_interface.vm_client.*.ip_configuration.private_ip_address}"
}
output "public_ip_address_vm_client" {
  value = "${azurerm_public_ip.vm_client.*.ip_address}"
}

output "fqdn_vm_byod" {
  value = "${azurerm_public_ip.vm_byod.*.fqdn}"
}
output "private_ip_address_vm_byod" {
  value = "${azurerm_network_interface.vm_byod.*.ip_configuration.private_ip_address}"
}
output "public_ip_address_vm_byod" {
  value = "${azurerm_public_ip.vm_byod.*.ip_address}"
}

output "fqdn_vm_rdsh" {
  value = "${azurerm_public_ip.vm_rdsh.*.fqdn}"
}
output "private_ip_address_vm_rdsh" {
  value = "${azurerm_network_interface.vm_rdsh.*.ip_configuration.private_ip_address}"
}
output "public_ip_address_vm_rdsh" {
  value = "${azurerm_public_ip.vm_rdsh.*.ip_address}"
}