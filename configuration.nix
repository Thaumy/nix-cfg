{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot/efi";
    };
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_6_1;
  };

  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [

      (writeShellScriptBin "backup"
        (builtins.readFile /home/thaumy/app/sh/backup/backup.sh))

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
      wget
      tree
      htop
      glow
      ocaml
      xclip
      p7zip
      xmrig
      clash
      docker
      nodejs
      podman
      vscode
      nixfmt
      vsftpd
      mysql80
      postman
      yarn2nix
      tdesktop
      python39
      patchelf
      neofetch
      chromium
      nix-index
      distrobox
      wireshark
      wpsoffice
      monero-gui
      obs-studio
      pkg-config
      nixpkgs-fmt
      dotnet-sdk_7
      #home-manager
      ffmpeg_5-full
      postgresql_15
      github-desktop
      android-studio
      element-desktop

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
    ];
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome.gnome-maps
      gnome.gnome-music
      gnome.simple-scan
      gnome.gnome-weather
      gnome.gnome-contacts
    ];
    variables = { EDITOR = "nvim"; };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
    fish.enable = true;

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
        customRC = (builtins.readFile /home/thaumy/cfg/neovim/vimrc);
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thaumy = {
    description = "Thaumy";
    isNormalUser = true;
    shell = pkgs.fish;
    packages = with pkgs; [ ];
    extraGroups = [ "networkmanager" "wheel" ];
  };

  networking = {
    hostName = "nixos";

    # Enable networking
    networkmanager.enable = true;

    # Configure network proxy if necessary
    proxy.default = "http://localhost:7890";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enables wireless support via wpa_supplicant.
    # wireless.enable = true;
  };

  time.timeZone = "Asia/Shanghai";

  i18n = let locale = "en_US.UTF-8";
  in {
    defaultLocale = locale;
    inputMethod = {
      enabled = "fcitx5";
      fcitx5 = { addons = with pkgs; [ fcitx5-chinese-addons ]; };
    };
    extraLocaleSettings = {
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
  };

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
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
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  systemd.services = {
    # Workaround for GNOME autologin:
    # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
    clash_daemon = {
      enable = true;
      after = [ "network.target" ];
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        ExecStart = "${pkgs.clash}/bin/clash -d /home/thaumy/cfg/clash";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nixpkgs = {
    overlays = [
      (import (builtins.fetchTarball
        "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };
}
