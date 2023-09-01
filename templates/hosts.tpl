${yamlencode({
  "all": {
    "dc": {
      for i, ip in dc:
        "dc${i+1}" => {
          "ip": "${ip}",
          "name": "dc${i+1}"
        }
    },
        "rdsh": {
      for i, ip in rdsh:
        "rdsh${i+1}" => {
          "ip": "${ip}",
          "name": "rdsh${i+1}"
        }
    }
  }
})}