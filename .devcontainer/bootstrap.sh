#!/bin/bash
set -e

echo "[BOOTSTRAP] Запуск 01-setup-docker.sh..."
bash "$(dirname "$0")/scripts/01-setup-docker.sh"

echo "[BOOTSTRAP] Запуск 02-install-openvpn.sh..."
bash "$(dirname "$0")/scripts/02-install-openvpn.sh"

echo "[BOOTSTRAP] Все шаги выполнены успешно."
