# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content           = templatefile("${path.module}/ansible/templates/hosts.tpl",
    {
      # controller = azurerm_network_interface.vm_controller.*.ip_configuration.private_ip_address
      controller    = "${element(azurerm_network_interface.vm_controller.*.ip_configuration.private_ip_address, count.index)}"
      dc            = "${element(azurerm_network_interface.vm_dc.*.ip_configuration.private_ip_address, count.index)}"
      rdsh          = "${element(azurerm_network_interface.vm_rdsh.*.ip_configuration.private_ip_address, count.index)}"
      client        = "${element(azurerm_network_interface.vm_client.*.ip_configuration.private_ip_address, count.index)}"
      byod          = "${element(azurerm_network_interface.vm_byod.*.ip_configuration.private_ip_address, count.index)}"
    }
  )
  filename          = "../ansible/inventory_test"
}