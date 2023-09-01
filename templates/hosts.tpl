${yamlencode({
  "all": {
    "dc": {
      for i, ip in dc:
        "dc${i+1}" => {
          "ip": "${ip}",
          "name": dc${i+1}
        }
    }
  }
})}