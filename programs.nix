{ config, pkgs, ... }:

{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    ssh.startAgent = false;

    fish = {
      enable = true;
      shellAliases = {
        cat = "bat";
      };
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      configure = {
        customRC = (builtins.readFile /home/thaumy/cfg/neovim/rc);
      };
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
