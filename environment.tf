# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content           = templatefile("${path.module}/templates/hosts.tpl",
    {
      dc            = "${azurerm_network_interface.vm_dc.*.private_ip_address} hostname = dc${azurerm_network_interface.vm_dc.*.index}"
      rdsh          = "${azurerm_network_interface.vm_rdsh.*.private_ip_address} hostname = rdsh${azurerm_network_interface.vm_dc.*.index}"
      client        = "${azurerm_network_interface.vm_client.*.private_ip_address} hostname = client${azurerm_network_interface.vm_dc.*.index}"
      byod          = "${azurerm_network_interface.vm_byod.*.private_ip_address} hostname = byod${azurerm_network_interface.vm_dc.*.index}"
    }
  )
  filename          = "${path.module}/ansible/inventory"
}