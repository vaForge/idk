#!/bin/bash

set -e

sudo apt update

sudo apt install -y curl wget gnupg fontconfig openjdk-17-jre

sudo mkdir -p /usr/share/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \
| sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" \
| sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt update

sudo apt install -y jenkins

sudo systemctl enable jenkins

sudo systemctl restart jenkins

sleep 5

sudo systemctl status jenkins --no-pager

echo
echo "===================================================="
echo "JENKINS INITIAL ADMIN PASSWORD"
echo "===================================================="
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo
echo "===================================================="
echo "Open: http://localhost:8080"
echo "===================================================="
