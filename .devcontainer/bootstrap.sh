#!/bin/bash
set -e

SESSION="mysession"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts"

# Проверка tmux
if ! command -v tmux &>/dev/null; then
    echo "[!] tmux не установлен. Устанавливаю..."
    sudo apt update && sudo apt install -y tmux
fi

# Убиваем предыдущую сессию (если была)
tmux kill-session -t "$SESSION" 2>/dev/null || true

# Создание новой сессии и первой панели
tmux new-session -d -s "$SESSION" -n setup

# Левая панель (основная)
tmux send-keys -t "$SESSION":0.0 "bash $SCRIPT_DIR/01-setup-docker.sh" C-m

# Правая панель
tmux split-window -h -t "$SESSION"
tmux send-keys -t "$SESSION":0.1 "bash $SCRIPT_DIR/02-install-openvpn.sh" C-m

# Нижняя панель на правой стороне
tmux select-pane -t "$SESSION":0.1
tmux split-window -v -t "$SESSION"
tmux send-keys -t "$SESSION":0.2 "bash $SCRIPT_DIR/03-install-openvpn.sh" C-m

# Раскладка
tmux select-layout -t "$SESSION" tiled

# Присоединяемся
tmux attach-session -t "$SESSION"
