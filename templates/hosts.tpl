${yamlencode({
  "all": {
    "windows-domain-member": {
      "hosts": {
        for i, ip in rdsh:
          "rdsh${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "rdsh${i+1}"
          }
      },
      "hosts": {
        for i, ip in client:
          "client${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "client${i+1}"
          }
      }
    },
    "windows-dc": {
      "hosts": {
        for i, ip in dc:
          "dc${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "dc${i+1}"
          }
      }
    },
    "windows-client": {
      "hosts": {
        for i, ip in client:
          "client${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "client${i+1}"
          }
      }
    },
    "windows-rdsh": {
      "hosts": {
        for i, ip in rdsh:
          "rdsh${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "rdsh${i+1}"
          }
      }
    },
        "linux-guacamole": {
      "hosts": {
        for i, ip in guac:
          "guac${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "guac${i+1}"
          }
      }
    },
    "windows-byod": {
      "hosts": {
        for i, ip in byod:
          "byod${i+1}" => {
            "ansible_host": "${ip}",
            "hostname": "byod${i+1}"
          }
      }
    }
  }
})}



linux-guacamole