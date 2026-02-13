```
 /$$   /$$                     /$$   /$$             /$$           /$$    /$$ /$$$$$$$   /$$$$$$ 
| $$  | $$                    | $$$ | $$            | $$          | $$   | $$| $$__  $$ /$$__  $$
| $$  | $$  /$$$$$$$  /$$$$$$ | $$$$| $$  /$$$$$$  /$$$$$$        | $$   | $$| $$  \ $$| $$  \__/
| $$$$$$$$ /$$_____/ /$$__  $$| $$ $$ $$ /$$__  $$|_  $$_/        |  $$ / $$/| $$$$$$$/|  $$$$$$ 
| $$__  $$|  $$$$$$ | $$  \__/| $$  $$$$| $$$$$$$$  | $$           \  $$ $$/ | $$____/  \____  $$
| $$  | $$ \____  $$| $$      | $$\  $$$| $$_____/  | $$ /$$        \  $$$/  | $$       /$$  \ $$
| $$  | $$ /$$$$$$$/| $$      | $$ \  $$|  $$$$$$$  |  $$$$/         \  $/   | $$      |  $$$$$$/
|__/  |__/|_______/ |__/      |__/  \__/ \_______/   \___/            \_/    |__/       \______/ 
```                                                                                                 


```bash
# apply flake for hostname
sudo nixos-rebuild switch --flake ~/nixos-config#HOSTNAME

# gen sop key user
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# generate host sop key
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'


# clear nix cache
nix-collect-garbage -d
```
