# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  count                = "${var.azure-environment.instance_count}"
  content = <<-EOT
    %{ for ip in "${element(azurerm_network_interface.vm_byod.*.ip_configuration.private_ip_address, count.index)}" ~}
    ${ip} ansible_ssh_user=ec2-user
    %{ endfor ~}
  EOT
  filename          = "../ansible/inventory_test"
}