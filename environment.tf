# generate inventory file for Ansible
resource "local_file" "hosts_cfg" {
  content = <<-EOT
    %{ for ip in azurerm_network_interface.vm_controller.*.ip_configuration.ipv4_address ~}
    ${ip} ansible_ssh_user=ec2-user
    %{ endfor ~}
  EOT
  filename          = "../ansible/inventory_test"
}