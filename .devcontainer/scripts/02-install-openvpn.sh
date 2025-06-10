#!/bin/bash

sudo docker exec -it ubuntu_gui bash
# Установка OpenVPN и curl
apt update
apt install -y openvpn curl
