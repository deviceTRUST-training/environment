# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content           = templatefile("${path.module}/ansible/templates/hosts.tpl",
    {
      dc            = "${azurerm_network_interface.vm_dc.*.private_ip_address}"
      rdsh          = "${azurerm_network_interface.vm_rdsh.*.private_ip_address}"
      client        = "${azurerm_network_interface.vm_client.*.private_ip_address}"
      byod          = "${azurerm_network_interface.vm_byod.*.private_ip_address}"
    }
  )
  filename          = "${path.module}/ansible/inventory"
}