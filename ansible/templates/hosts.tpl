[windows]
%{ for ip in windows-dc ~}
${ip} hostname=dc
%{ endfor ~}
%{ for ip in rdsh ~}
${ip} hostname=rdsh
%{ endfor ~}
%{ for ip in client ~}
${ip} hostname=client
%{ endfor ~}
%{ for ip in byod ~}
${ip} hostname=byod
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