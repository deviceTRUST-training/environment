# generate inventory file for Ansible
resource "local_file" "templatefile" {
  count                = "${var.azure-environment.instance_count}"

  content = "${element(azurerm_resource_group.main.*.location, count.index)}"
  filename          = "/ansible/inventory_test"
}