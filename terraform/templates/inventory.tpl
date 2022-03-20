[all:children]
k8s_masters
k8s_workers

[k8s_masters]
%{ for ip in k8s_masters ~}
${ip}
%{ endfor ~}

[k8s_workers]
%{ for ip in k8s_workers ~}
${ip}
%{ endfor ~}

[all:vars]
ansible_ssh_private_key_file = ${private_key_path}