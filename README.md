```bash
# apply flake for hostname
sudo nixos-rebuild switch --flake ~/nixos-config#HOSTNAME

# gen sop key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# clear nix cache
nix-collect-garbage -d
```
