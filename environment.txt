# generate inventory file for Ansible
resource "local_file" "templatefile" {
  count                = "${var.azure-environment.instance_count}"

  content = {azurerm_virtual_machine.vm_client.*.name}
  filename          = "/ansible/inventory_test"
}