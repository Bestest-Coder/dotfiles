#!/bin/sh
sudo ln -sf $(dirname $(realpath "$0"))/flake.nix /etc/nixos/flake.nix
