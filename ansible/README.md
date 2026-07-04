# Part 2 - Ansible Configuration Management

## Purpose
This directory contains the Ansible automation used to configure the AWS EC2 instance from Part 1. It installs Docker and ensures it starts automatically on boot.

## Files
- inventory.ini: Defines the target host, SSH user, and private key location.
- install_docker.yml: The Ansible playbook that installs and configures Docker.

## Automation Flow
1. apt update refreshes the package cache.
2. Required dependencies are installed (apt-transport-https, ca-certificates, curl, software-properties-common).
3. Dockers official GPG key is added.
4. Dockers official APT repository is added.
5. Docker Engine (docker-ce) is installed.
6. The Docker service is started and enabled for auto-start on boot.
7. The ubuntu user is added to the docker group.

## How to Run
ansible -i inventory.ini docker_servers -m ping
ansible-playbook -i inventory.ini install_docker.yml

## Verification
docker --version
sudo systemctl status docker
sudo systemctl is-enabled docker
