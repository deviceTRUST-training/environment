${yamlencode({
  "all": {
    "windows": {
      for i, ip in dc:
        "dc${i+1}" => {
          "ansible_host": "${ip}",
          "hostname": "dc${i+1}"
        }
    },
    "rdsh": {
      for i, ip in rdsh:
        "rdsh${i+1}" => {
          "ansible_host": "${ip}",
          "hostname": "rdsh${i+1}"
        }
    },
    "client": {
      for i, ip in client:
        "client${i+1}" => {
          "ansible_host": "${ip}",
          "hostname": "client${i+1}"
        }
    },
    "byod": {
      for i, ip in byod:
        "byod${i+1}" => {
          "ansible_host": "${ip}",
          "hostname": "byod${i+1}"
        }
    }
  }
})}