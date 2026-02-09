#!/usr/bin/env bash 
git add -N .
sudo nixos-rebuild switch --flake ~/nixos-config#$(hostname -s) 
#nix-collect-garbage -d