#!/bin/sh
sudo mv /etc/nixos /etc/nixos.bak
sudo ln -sf $(dirname $(realpath "$0"))/../ /etc/nixos/
