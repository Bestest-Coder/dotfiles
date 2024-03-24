#!/bin/sh
sudo mv /etc/NIXOS /etc/nixos.bak
sudo ln -sf $(dirname $(realpath "$0"))/../ /etc/NIXOS/
