{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./i18n.nix
    ./pkgs.nix
    ./programs.nix
    ./services.nix
    ./hardware.nix
  ];

  environment = {
    localBinInPath = true;

    gnome.excludePackages = with pkgs; [
      kgx
      epiphany
      gnome-tour
      gnome.yelp
      gnome.totem
      gnome.gnome-maps
      gnome.gnome-music
      gnome.simple-scan
      gnome.gnome-clocks
      gnome.gnome-weather
      gnome.gnome-calendar
      gnome.gnome-contacts
    ];
    variables = { EDITOR = "nvim"; };
    sessionVariables = {
      # NIXOS_OZONE_WL = "1";
      DOTNET_ROOT = "${pkgs.dotnet-sdk_7}";
      PATH = [
        "/home/thaumy/.dotnet/tools"
      ];
    };
    #shellInit = ''
    #  gpgconf --launch gpg-agent
    #  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    #'';
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

  hardware = {
    bluetooth.enable = true;
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
    clash-daemon = {
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

  # networking.firewall.allowedTCPPorts = [ 40040 ];
  # networking.firewall.allowedUDPPorts = [  ];
  networking.firewall.enable = false;

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  nixpkgs = {
    overlays = [
      (import ./overlay/rust.nix)
      # (import ./overlay/vscode.nix)
      (import ./overlay/chromium.nix)
    ];
    config = {
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
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
  };
}