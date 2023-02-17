{ config, pkgs, ... }:

let
  pkgs-stable = import <nixos-22.11> { config = { allowUnfree = true; }; };

  sh = with pkgs;[
    (writeShellScriptBin "aes-en"
      (builtins.readFile /home/thaumy/sh/crypto/aes-en.sh))
    (writeShellScriptBin "aes-de"
      (builtins.readFile /home/thaumy/sh/crypto/aes-de.sh))
    (writeShellScriptBin "memdir"
      (builtins.readFile /home/thaumy/sh/memdir/run.sh))
    (writeShellScriptBin "backup"
      (builtins.readFile /home/thaumy/sh/backup/run.sh))
    (writeShellScriptBin "disable-kb"
      (builtins.readFile /home/thaumy/sh/disable-kb/run.sh))
    (writeShellScriptBin "update-clash-sub"
      (builtins.readFile /home/thaumy/sh/update-clash-sub/run.sh))
  ];

  sdk = with pkgs;[
    go
    jdk
    gcc
    ocaml
    stack
    nodejs
    python39
    clang-tools
    dotnet-sdk_7
    android-tools
    (rust-bin.nightly."2023-01-11".default.override {
      extensions = [ "rust-src" ];
    })
  ];

  editor = with pkgs;[
    glow
    vscode
    pkgs-stable.wpsoffice
    pkgs-stable.libreoffice
    android-studio
    jetbrains.rider
    jetbrains.clion
    jetbrains.goland
    jetbrains.datagrip
    jetbrains.webstorm
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
  ];

  infra = with pkgs;[
    jq
    git
    nmap
    wget
    tree
    htop
    p7zip
    xclip
    podman
    pstree
    evtest
    nixfmt
    libinput
    patchelf
    nix-index
    steam-run
    pkg-config
    nixpkgs-fmt
  ];

  db = with pkgs;[
    mysql80
    postgresql_15
  ];

  im = with pkgs;[
    tdesktop
    element-desktop
  ];

  lsp = with pkgs;[
    sqls
    deno
    gopls
    rnix-lsp
    marksman
    rust-analyzer
    omnisharp-roslyn
    jdt-language-server
    nodePackages.pyright
    kotlin-language-server
    sumneko-lua-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    haskellPackages.haskell-language-server
    nodePackages.vscode-langservers-extracted
  ];

  sec = with pkgs;[
    openssl
    paperkey
    yubikey-manager
    yubikey-personalization
  ];

  etc = with pkgs;[
    nur.repos.thaumy.idbuilder
    nur.repos.linyinfeng.wemeet
    nur.repos.thaumy.microsoft-todo-electron

    vlc
    bat
    gimp
    steam
    xmrig
    clash
    docker
    vsftpd
    gparted
    postman
    qrencode
    yarn2nix
    neofetch
    chromium
    distrobox
    wireshark
    monero-gui
    obs-studio
    # home-manager
    ffmpeg_5-full
    github-desktop

    gnome.mutter
    gnome.gnome-boxes
    gnome.gnome-tweaks
    gnome.gnome-terminal
    gnomeExtensions.tiling-assistant
  ];
in
{
  environment.systemPackages =
    sh ++
    sdk ++
    editor ++
    infra ++
    db ++
    im ++
    lsp ++
    sec ++
    etc;
}
