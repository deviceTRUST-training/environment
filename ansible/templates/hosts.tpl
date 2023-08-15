[windows]
%{ for ip in windows-dc ~}
${ip} hostname=dc
%{ endfor ~}

[windows-dc]
%{ for ip in windows-dc ~}
${ip}
%{ endfor ~}