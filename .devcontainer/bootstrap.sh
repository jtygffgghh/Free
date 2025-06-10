#!/bin/bash
set -e

SESSION="mysession"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

echo "[BOOTSTRAP] Запуск tmux-сессии с 3 панелями..."

# Проверка и установка tmux
if ! command -v tmux &>/dev/null; then
    echo "[+] Установка tmux..."
    sudo apt update && sudo apt install -y tmux
fi

# Удаление предыдущей сессии, если была
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Создание новой tmux-сессии
tmux new-session -d -s "$SESSION" -n setup

# Левая панель — установка Docker и запуск контейнера
tmux send-keys -t "$SESSION":0.0 "bash $SCRIPT_DIR/01-setup-docker.sh" C-m

# Правая панель сверху — установка OpenVPN
tmux split-window -h -t "$SESSION"
tmux send-keys -t "$SESSION":0.1 "bash $SCRIPT_DIR/02-install-openvpn.sh" C-m

# Нижняя панель справа — второй OpenVPN-скрипт
tmux select-pane -t "$SESSION":0.1
tmux split-window -v -t "$SESSION"
tmux send-keys -t "$SESSION":0.2 "bash $SCRIPT_DIR/03-install-openvpn.sh" C-m

# Выравнивание панелей
tmux select-layout -t "$SESSION" tiled

# Автозапуск внутри Codespaces (не подключаемся вручную к сессии)
echo "[BOOTSTRAP] Все скрипты запущены в фоновом режиме через tmux."
