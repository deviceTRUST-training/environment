[windows]
%{ for ip in dc ~}
${ip} hostname=dc${[index]}
%{ endfor ~}
%{ for ip in rdsh ~}
${ip} hostname=rdsh${[index]}
%{ endfor ~}
%{ for ip in client ~}
${ip} hostname=client${[index]}
%{ endfor ~}
%{ for ip in byod ~}
${ip} hostname=byod${[index]}
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