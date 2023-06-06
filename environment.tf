# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/ansible/templates/hosts.tpl",
    {
      controller = azurerm_network_interface.vm_controller.*.ip_configuration.private_ip_address
      dc = azurerm_network_interface.vm_dc.*.ip_configuration.private_ip_address
      rdsh = azurerm_network_interface.vm_rdsh.*.ip_configuration.private_ip_address
      client = azurerm_network_interface.vm_cient.*.ip_configuration.private_ip_address
      byod = azurerm_network_interface.vm_byod.*.ip_configuration.private_ip_address
    }
  )
  filename = "../ansible/inventory_test"
}