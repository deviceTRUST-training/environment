variable azure-environment {
  type                = map
  description         = ""
  default = {
    subscription_id   = "1087b067-72b6-4f7f-9999-a9c3172a9ae4"
    tenant_id         = "07c7e7f5-210d-4fc6-bd6d-929caf1e3b61"
    client_id         = "4eec80f4-cb7a-44fb-b4e8-3c3a8b826a22"
    client_secret     = "Bth8Q~qCXjCfGENn5NoSY5Mb8wpgcXNSmI4u5cbh" #
    prefix            = "training"
    location          = "West Europe"
    instance_count    = "2"
  }
}

variable "tags" {
  type                = map
  default     = {
      environment     = "training"
  }
  description         = "Any tags which should be assigned to the resources in this example"
}

variable vm {
  type                    = map
  description             = ""
  default = {
    username              = "localadmin"
    password              = "S00perSecurePassw0rd2023"
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