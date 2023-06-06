# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  count                = "${var.azure-environment.instance_count}"
  content = "${element(azurerm_network_interface.vm_dc.*.ip_configuration.private_ip_address, count.index)}"
  filename          = "../ansible/inventory_test"
}