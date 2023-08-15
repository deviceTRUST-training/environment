[windows]
%{ for ip in dc ~}
${ip} hostname=dc
%{ endfor ~}

[windows-dc]
%{ for ip in dc ~}
${ip}
%{ endfor ~}