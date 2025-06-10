#!/bin/bash



# Обновление и установка Docker и Docker Compose

echo "[+] Обновление пакетов и установка Docker и Docker Compose..."

sudo apt update && sudo apt install -y docker.io docker-compose



# Проверка, установлен ли Docker

if ! command -v docker &> /dev/null; then

  echo "[-] Docker не установлен. Прерывание."

  exit 1

fi



# Создание рабочей директории

echo "[+] Создание директории dockercom..."

mkdir -p ~/dockercom

cd ~/dockercom || exit 1



# Создание Docker Compose файла с доступом к TUN

echo "[+] Создание файла ubuntu_gui.yml с доступом к TUN..."

cat > ubuntu_gui.yml <<EOF

version: '3.8'

services:

  ubuntu-gui:

    image: dorowu/ubuntu-desktop-lxde-vnc:bionic

    container_name: ubuntu_gui

    ports:

      - "6080:80"       # noVNC (http://localhost:6080)

      - "5900:5900"     # VNC клиент (опционально)

    environment:

      - VNC_PASSWORD=pass123

    volumes:

      - ./data:/data

      - /dev/net/tun:/dev/net/tun     # Доступ к TUN-устройству

    cap_add:

      - NET_ADMIN                     # Права для настройки сети

    devices:

      - /dev/net/tun

    privileged: true                 # (опционально, если нужно всё)

    shm_size: "2g"

EOF



# Запуск контейнера

echo "[+] Запуск контейнера с GUI и поддержкой VPN (TUN)..."

sudo docker-compose -f ubuntu_gui.yml up -d



# Проверка

echo "[+] Проверка запущенных контейнеров:"

sudo docker ps
