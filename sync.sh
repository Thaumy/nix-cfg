declare configuration=$(cat /etc/nixos/configuration.nix)
touch configuration.nix
echo "$configuration" > configuration.nix
