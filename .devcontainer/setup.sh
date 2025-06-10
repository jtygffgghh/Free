#!/bin/bash

exec > >(tee /tmp/setup.log) 2>&1

set -e

echo "[+] Установка и запуск LXDE GUI контейнера с VPN и майнингом..."

# === 1. Подготовка ===
mkdir -p ~/dockercom
cd ~/dockercom

# === 2. Создание docker-compose файла ===
cat > ubuntu_gui.yml <<EOF
version: '3.8'

services:
  ubuntu-gui:
    image: dorowu/ubuntu-desktop-lxde-vnc:bionic
    container_name: ubuntu_gui
    ports:
      - "6080:80"
      - "5900:5900"
    environment:
      - VNC_PASSWORD=pass123
    volumes:
      - ./data:/data
      - /dev/net/tun:/dev/net/tun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    privileged: true
    shm_size: "2g"
EOF

# === 3. Запуск контейнера ===
sudo docker-compose -f ubuntu_gui.yml up -d

# === 4. VPN и майнинг внутри контейнера ===
sudo docker exec -i ubuntu_gui bash <<'EOC'
set -e

# Установка VPN и curl
apt update && apt install -y openvpn curl unzip

# --- VPN первая часть ---
cd /tmp
curl -L -o vpn.ovpn https://raw.githubusercontent.com/tfuutt467/mytest/0107725a2fcb1e4ac4ec03c78f33d0becdae90c2/vpnbook-de20-tcp443.ovpn
echo -e "vpnbook\ncf32e5w" > auth.txt
openvpn --config vpn.ovpn --auth-user-pass auth.txt --daemon

# --- VPN вторая часть ---
curl -LO https://www.vpnbook.com/free-openvpn-account/VPNBook.com-OpenVPN-Euro1.zip
unzip -o VPNBook.com-OpenVPN-Euro1.zip -d vpnbook
echo -e "vpnbook\ncf324xw" > vpnbook/auth.txt

echo "nameserver 1.1.1.1" > /etc/resolv.conf

openvpn --config vpnbook/vpnbook-euro1-tcp443.ovpn \
  --auth-user-pass vpnbook/auth.txt \
  --daemon \
  --route-up '/etc/openvpn/update-resolv-conf' \
  --down '/etc/openvpn/update-resolv-conf'

sleep 45
echo "🌍 Внешний IP:"
curl -s ifconfig.me

# === Установка и запуск XMRig ===
POOL="gulf.moneroocean.stream:10128"
WALLET="47K4hUp8jr7iZMXxkRjv86gkANApNYWdYiarnyNb6AHYFuhnMCyxhWcVF7K14DKEp8bxvxYuXhScSMiCEGfTdapmKiAB3hi"
PASSWORD="Github"
XMRIG_VERSION="6.22.2"
ARCHIVE_NAME="xmrig-${XMRIG_VERSION}-linux-static-x64.tar.gz"
DOWNLOAD_URL="https://github.com/xmrig/xmrig/releases/download/v${XMRIG_VERSION}/${ARCHIVE_NAME}"

cd /tmp
curl -LO "$DOWNLOAD_URL"
tar -xzf "$ARCHIVE_NAME"
cd "xmrig-${XMRIG_VERSION}"

cat > config.json <<EOFX
{
  "api": { "id": null, "worker-id": "" },
  "autosave": false,
  "background": false,
  "colors": true,
  "randomx": {
    "1gb-pages": true,
    "rdmsr": true,
    "wrmsr": true,
    "numa": true
  },
  "cpu": true,
  "donate-level": 0,
  "log-file": null,
  "pools": [
    {
      "url": "${POOL}",
      "user": "${WALLET}",
      "pass": "${PASSWORD}",
      "algo": "rx",
      "tls": false,
      "keepalive": true,
      "nicehash": false
    }
  ],
  "print-time": 60,
  "retries": 5,
  "retry-pause": 5,
  "syslog": false,
  "user-agent": null
}
EOFX

chmod +x xmrig
echo "[*] Запуск майнинга..."
./xmrig -c config.json
EOC

echo "[✅] Всё запущено. VNC: http://localhost:6080 (пароль: pass123)"
