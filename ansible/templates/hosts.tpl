[windows]
%{ for ip in dc ~}
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

[dc]
%{ for ip in dc ~}
${ip}
%{ endfor ~}

[domain-members]
%{ for ip in rdsh ~}
${ip}
%{ endfor ~}
%{ for ip in client ~}
${ip}
%{ endfor ~}
%{ for ip in byod ~}
${ip}
%{ endfor ~}

[rdsh]
%{ for ip in rdsh ~}
${ip}
%{ endfor ~}

[client]
%{ for ip in client ~}
${ip}
%{ endfor ~}

[byod]
%{ for ip in byod ~}
${ip}
%{ endfor ~}