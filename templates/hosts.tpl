${yamlencode({
  "all": {
    "dc": {
      for i, ip in dc:
        "dc${i+1}" => {
          "ip": "${ip}",
          "name": dc${i+1}
        }
    },
     "rdsh": {
      for i, ip in rdsh:
        "rdsh${i+1}" => {
          "ip": "${ip}",
          "name": rdsh${i+1}
        }
    },
    "byod": {
      for i, ip in byod:
        "byod${i+1}" => {
          "ip": "${ip}",
          "name": byod${i+1}
        }
    },
    "client": {
      for i, ip in client:
        "client${i+1}" => {
          "ip": "${ip}",
          "name": client${i+1}
        }
    }
  }
})}