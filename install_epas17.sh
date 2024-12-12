#!/bin/bash

echo "--- Running Bootstrap_general.sh ---"
ufw disable

echo "--- Configuring repo ---"
EDBTOKEN=$(cat /vagrant/.edbtoken)
export DEBIAN_FRONTEND=noninteractive
curl -1sLf "https://downloads.enterprisedb.com/$EDBTOKEN/enterprise/setup.deb.sh" | bash

echo "--- Running updates ---"
apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y

echo "--- Installing EPAS ---"
apt-get install edb-as17-server -y