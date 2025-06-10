#!/bin/bash
set -e

echo "[+] Установка OpenVPN и curl внутри контейнера ubuntu_gui..."

sudo docker exec ubuntu_gui bash -c "apt update && apt install -y openvpn curl"

echo "[+] Установка завершена."
