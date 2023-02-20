{ config, pkgs, ... }:

{

  fonts = {

    enableDefaultFonts = true;

    fonts = with pkgs;[
      nerdfonts
      noto-fonts
      sarasa-gothic
      jetbrains-mono
      liberation_ttf
      twemoji-color-font
    ];

    fontconfig = {
      defaultFonts = {
        emoji = [ "Twitter Color Emoji" ];
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Sarasa UI SC" ];
        monospace = [ "JetBrains Mono" ];
      };
    };

  };

}
