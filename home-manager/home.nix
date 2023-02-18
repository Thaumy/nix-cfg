{ config, pkgs, ... }:

{
  imports = [
    ./gpg.nix
    ./pkgs.nix
    ./fish.nix
  ];

  home = {
    username = "thaumy";
    stateVersion = "21.11";
    homeDirectory = "/home/thaumy";
  };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import
        (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz")
        {
          inherit pkgs;
        };
    };
  };

}
