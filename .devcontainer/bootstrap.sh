#!/bin/bash
set -e

echo "[BOOTSTRAP] Запуск tmux-сессии с тремя скриптами..."

# Проверка и установка tmux
if ! command -v tmux &> /dev/null; then
    echo "[!] tmux не установлен. Устанавливаю..."
    sudo apt update && sudo apt install -y tmux
fi

# Путь к скриптам
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

# Запуск новой tmux-сессии с первой панелью
tmux new-session -d -s mysession -n setup "bash $SCRIPT_DIR/01-setup-docker.sh"

# Создание правой вертикальной панели и запуск второго скрипта
tmux split-window -h "bash $SCRIPT_DIR/02-install-openvpn.sh"

# Переключение на правую панель и разбиение её горизонтально
tmux select-pane -t 1
tmux split-window -v "bash $SCRIPT_DIR/03-install-openvpn.sh"

# Выравнивание панелей
tmux select-layout tiled

# Присоединение к сессии
tmux -2 attach-session -t mysession
