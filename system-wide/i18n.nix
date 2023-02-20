{ config, pkgs, ... }:

let
  locale = "en_US.UTF-8";
in
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-chinese-addons ];
  };

  i18n.defaultLocale = locale;

  i18n.extraLocaleSettings = {
    LC_NAME = locale;
    LC_TIME = locale;
    LC_PAPER = locale;
    LC_NUMERIC = locale;
    LC_ADDRESS = locale;
    LC_MONETARY = locale;
    LC_TELEPHONE = locale;
    LC_MEASUREMENT = locale;
    LC_IDENTIFICATION = locale;
  };

}

