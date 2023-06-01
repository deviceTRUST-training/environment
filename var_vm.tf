variable vm {
  type = map
  description = ""
  default = {
    username = "localadmin"
    password = "S00perSecurePassword!"
    domain_dns_name = "dt.training"
    domain_netbios_name = "dt"
    ip_dc = "10.10.11.10"
    ip_client = "10.10.11.101"
    ip_byod = "10.10.11.102"
    ip_rdsh = "10.10.11.111"
    ip_controller = "10.10.11.201"
  }
}