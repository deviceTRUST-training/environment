variable vm {
  type                    = map
  description             = ""
  default = {
    username              = "localadmin"
    password              = "S00perSecurePassword!"
    domain_dns_name       = "dt.training"
    domain_netbios_name   = "dt"
    ip_dc                 = "1"
    ip_controller         = "1"
    ip_guacamole          = "2"
    ip_rdsh               = "1"
    ip_byod               = "3"
    ip_client             = "2"
  }
}