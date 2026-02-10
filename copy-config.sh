#!/usr/bin/env bash 

echo -n "Enter hostname: "
read hostname

mkdir hosts/$hostname &&
    sudo cp /etc/nixos/* hosts/$hostname &&
    sudo mv /etc/nixos /etc/nixos.bak &&
    sudo chown $USER hosts/$hostname/* &&
    mv hosts/$hostname/configuration.nix hosts/$hostname/default.nix 

echo "Done... don't forget to update config and add to flake"



