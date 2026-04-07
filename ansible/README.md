# Ansible

Automation tool for deploying and maintaining multiple machines

Files to generate before running the backup.yaml playbook:
- inventory
```
[pi]
<ip for raspberry pi>

[homelab]
<any additional servers that need to backup> 

...
```

- group_vars/all.yaml
```
PI_SSH_HOST: "USER@IP"
BACKUP_SOURCE_PATH: "PATH_TO_FOLDER_TO_BACKUP"
DOCKER_CONFIG_VOLUME_PATH: "PATH_TO_DOCKER_CONFIG"
PI_DOCKER_CONFIG_VOLUME_DESTINATION_PATH: "DESTINATION_TO_STORE_PI_DOCKER_CONFIG"
DEBIAN_DOCKER_CONFIG_VOLUME_DESTINATION_PATH: "DESTINATION_TO_STORE_DEBIAN_DOCKER_CONFIG"
RESTIC_REPOSITORY: "sftp:{{ PI_SSH_HOST }}:BACKUP_DESTINATION_FOLDER"
RESTIC_PASSWORD: "RESTIC_PASSWORD"
```