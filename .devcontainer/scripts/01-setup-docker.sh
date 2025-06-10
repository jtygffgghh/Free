#!/bin/bash
set -e

echo "[01] Установка Docker и Docker Compose..."

sudo apt update && sudo apt install -y docker.io docker-compose

if ! command -v docker &> /dev/null; then
  echo "[-] Docker не установлен. Прерывание."
  exit 1
fi

echo "[01] Создание директории ~/dockercom..."
mkdir -p ~/dockercom
cd ~/dockercom || exit 1

echo "[01] Создание docker-compose файла ubuntu_gui.yml..."
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

echo "[01] Запуск контейнера..."
sudo docker-compose -f ubuntu_gui.yml up -d

echo "[01] Контейнер запущен. Список контейнеров:"
sudo docker ps
