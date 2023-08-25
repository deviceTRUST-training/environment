variable vm {
  type                    = map
  description             = ""
  default = {
    username              = "localadmin"
    password              = "S00perSecurePassword!"
    domain_dns_name       = "dt.training"
    domain_netbios_name   = "dt"
    ip_dc                 = "11"
    ip_controller         = "11"
    ip_guacamole          = "12"
    ip_rdsh               = "11"
    ip_client             = "12"
    ip_byod               = "13"
  }
}