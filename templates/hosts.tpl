${yamlencode({
  "all": {
    "hosts": {
      for i, ip in dc:
        "dc${i+1}" => {
          "ip": "${ip}",
          "ansible_port": 5986
        }
    }
  }
})}