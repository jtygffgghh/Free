#!/bin/bash

sudo docker exec -it ubuntu_gui bash
# Установка OpenVPN и curl
apt update
apt install -y openvpn curl

# Переход во временную директорию
cd /tmp

# Скачивание ovpn-конфига
curl -L -o vpn.ovpn https://raw.githubusercontent.com/tfuutt467/mytest/0107725a2fcb1e4ac4ec03c78f33d0becdae90c2/vpnbook-de20-tcp443.ovpn

# Создание файла с логином и паролем
cat > auth.txt <<EOF
vpnbook
cf32e5w
EOF

# Подключение к VPN
openvpn --config vpn.ovpn --auth-user-pass auth.txt
