#!/usr/bin/env bash 
sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname -s) && 
nix-collect-garbage -d