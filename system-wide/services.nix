{ config, pkgs, ... }:

{

  systemd.services = {
    # Workaround for GNOME autologin:
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  systemd.services.clash-daemon = {
    enable = true;
    after = [ "network.target" ];
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${pkgs.clash}/bin/clash -d /home/thaumy/cfg/clash";
    };
    wantedBy = [ "multi-user.target" ];
  };

  services = {
    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_15;
    };

    xserver = {
      enable = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Enable automatic login for the user.
      displayManager.autoLogin.enable = true;
      displayManager.autoLogin.user = "thaumy";

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;

      dpi = 180;
      videoDrivers = [ "nvidia" ];
      excludePackages = [ pkgs.xterm ];
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };
}
