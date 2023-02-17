{ config, pkgs, ... }:

{
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
