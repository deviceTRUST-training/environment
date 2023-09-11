# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content           = templatefile("${path.module}/templates/hosts.tpl",
    {
      dc            = "${azurerm_network_interface.vm_dc.*.private_ip_address}"
      guac          = "${azurerm_network_interface.vm_guacamole.*.private_ip_address}"
      rdsh          = "${azurerm_network_interface.vm_rdsh.*.private_ip_address}"
      client        = "${azurerm_network_interface.vm_client.*.private_ip_address}"
      byod          = "${azurerm_network_interface.vm_byod.*.private_ip_address}"
      member        = [
        "${azurerm_network_interface.vm_client.*.private_ip_address}",
        "${azurerm_network_interface.vm_rdsh.*.private_ip_address}"
      ]
      windows        = [
        "${azurerm_network_interface.vm_client.*.private_ip_address}",
        "${azurerm_network_interface.vm_rdsh.*.private_ip_address}",
        "${azurerm_network_interface.vm_byod.*.private_ip_address}",
        "${azurerm_network_interface.vm_dc.*.private_ip_address}"
      ]
    }
  )
  filename          = "${path.module}/ansible/inventory"
}