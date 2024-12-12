#!/bin/bash

echo "--- Running Bootstrap_epas.sh ---"
export EDBTOKEN=$(cat /vagrant/.edbtoken)

echo "--- Configuring repo ---"
curl -1sLf "https://downloads.enterprisedb.com/${EDBTOKEN}/enterprise/setup.rpm.sh" | sudo -E bash

echo "--- Running updates ---"
dnf update && dnf upgrade -y
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service

echo "--- Installing EPAS 17 ---"
sudo dnf install epel-release edb-as17-server -y
