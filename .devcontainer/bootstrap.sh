#!/bin/bash
set -e

SESSION="mysession"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

# Проверка tmux
if ! command -v tmux &>/dev/null; then
    echo "[+] Установка tmux..."
    sudo apt update && sudo apt install -y tmux
fi

# Удаление старой сессии
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Новая сессия
tmux new-session -d -s "$SESSION" -n setup

# Панель 1
tmux send-keys -t "$SESSION":0.0 "bash $SCRIPT_DIR/01-setup-docker.sh" C-m

# Панель 2
tmux split-window -h -t "$SESSION"
tmux send-keys -t "$SESSION":0.1 "bash $SCRIPT_DIR/02-install-openvpn.sh" C-m

# Панель 3
tmux select-pane -t "$SESSION":0.1
tmux split-window -v -t "$SESSION"
tmux send-keys -t "$SESSION":0.2 "bash $SCRIPT_DIR/03-install-openvpn.sh" C-m

tmux select-layout -t "$SESSION" tiled

# Подключаемся к сессии (ключевой момент!)
exec tmux attach-session -t "$SESSION"
