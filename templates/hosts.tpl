${yamlencode({
  "all": {
    "hosts": {
      for i, ip in rdsh:
        "rdsh${i+1}" => {
          "ip": "${ip}",
          "name": "rdsh${i+1}"
        }
    }
  }
})}