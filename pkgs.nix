{ pkgs, ... }:

with pkgs; [

  (writeShellScriptBin "backup"
    (builtins.readFile /home/thaumy/app/sh/backup/backup.sh))

  (writeShellScriptBin "disable_kb"
    (builtins.readFile /home/thaumy/app/sh/disable_kb/disable_kb.sh))

  nur.repos.thaumy.idbuilder
  nur.repos.thaumy.microsoft-todo-electron

  (rust-bin.nightly."2023-01-11".default.override {
    extensions = [ "rust-src" ];
  })

  jq
  go
  tor
  vlc
  git
  gcc
  jdk
  gimp
  nmap
  wget
  tree
  htop
  glow
  ocaml
  xclip
  p7zip
  xmrig
  clash
  steam
  docker
  nodejs
  podman
  vscode
  evtest
  nixfmt
  vsftpd
  mysql80
  gparted
  postman
  yarn2nix
  libinput
  tdesktop
  python39
  patchelf
  neofetch
  chromium
  nix-index
  steam-run
  #wpsoffice
  distrobox
  wireshark
  monero-gui
  obs-studio
  pkg-config
  nixpkgs-fmt
  dotnet-sdk_7
  #home-manager
  android-tools
  ffmpeg_5-full
  postgresql_15
  github-desktop
  android-studio
  element-desktop

  gnome.mutter
  gnome.gnome-boxes
  gnome.gnome-tweaks
  gnome.gnome-terminal

  jetbrains.rider
  jetbrains.clion
  jetbrains.goland
  jetbrains.datagrip
  jetbrains.webstorm
  jetbrains.idea-ultimate
  jetbrains.pycharm-professional
]
