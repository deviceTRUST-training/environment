# generate inventory file for Ansible
resource "local_file" "templatefile" {
  count                = "${var.azure-environment.instance_count}"

  content = "${var.azure-environment.prefix}_resources_${count.index}"
  filename          = "/ansible/inventory_test"
}