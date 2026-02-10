#!/usr/bin/env bash 
git add -N .
sudo nixos-rebuild switch --flake .#$(hostname -s) 
#nix-collect-garbage -d