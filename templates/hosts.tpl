[windows]
%{ for ip in dc ~}
${ip}
%{ endfor ~}
%{ for ip in rdsh ~}
${ip}
%{ endfor ~}
%{ for ip in client ~}
${ip}
%{ endfor ~}
%{ for ip in byod ~}
${ip}
%{ endfor ~}

[windows-dc]
%{ for ip in dc ~}
${ip}
%{ endfor ~}

[windows-domain-members]
%{ for ip in rdsh ~}
${ip}
%{ endfor ~}
%{ for ip in client ~}
${ip}
%{ endfor ~}
%{ for ip in byod ~}
${ip}
%{ endfor ~}

[windows-rdsh]
%{ for ip in rdsh ~}
${ip}
%{ endfor ~}

[windows-client]
%{ for ip in client ~}
${ip}
%{ endfor ~}

[windows-byod]
%{ for ip in byod ~}
${ip}
%{ endfor ~}

[linux-guacamole]
%{ for ip in guac ~}
${ip}
%{ endfor ~}