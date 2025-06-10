#!/bin/bash
set -e

echo "[BOOTSTRAP] Запуск начался"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[BOOTSTRAP] Выполняется: 01-setup-docker.sh"
bash "$SCRIPT_DIR/scripts/01-setup-docker.sh"

echo "[BOOTSTRAP] Ожидание запуска контейнера ubuntu_gui..."
until sudo docker ps | grep -q ubuntu_gui; do
    echo "[WAIT] Контейнер ещё не запущен, ожидание 2 секунды..."
    sleep 2
done

echo "[BOOTSTRAP] Контейнер найден. Выполняется: 02-install-openvpn.sh"
bash "$SCRIPT_DIR/scripts/02-install-openvpn.sh"

echo "[BOOTSTRAP] Все шаги выполнены успешно."
