#!/bin/bash
clear
RED='\033[0;31m'
echo -ne "${RED}Enter Domain name: "; read DNAME; \
echo -ne "${RED}Enter Vaultwarden Subdomain: "; read SDNAME; \
echo -ne "${RED}Enter Vaultwarden Port Number (VWPORTN:80): "; read VWPORTN; \
sed -i "s|01|${DNAME}|" .env && \
sed -i "s|02|${SDNAME}|" .env && \
sed -i "s|03|${VWPORTN}|" .env && \
rm README.md && \
TOKEN=$(openssl rand -base64 48); sed -i "s|CHANGE_ADMIN_TOKEN|${TOKEN}|" .env
while true; do
    read -p "Execute 'docker-compose up -d' now? (y/n)" yn
    case $yn in
        [Yy]* ) sudo docker compose up -d; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
