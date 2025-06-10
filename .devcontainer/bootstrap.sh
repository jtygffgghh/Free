#!/bin/bash
set -e

echo "[BOOTSTRAP] Запуск 01-setup-docker.sh..."
bash "$(dirname "$0")/scripts/01-setup-docker.sh"

# В будущем здесь можно добавлять другие скрипты:
# bash "$(dirname "$0")/scripts/02-install-vpn.sh"
# bash "$(dirname "$0")/scripts/03-start-miner.sh"

echo "[BOOTSTRAP] Все шаги выполнены успешно."
