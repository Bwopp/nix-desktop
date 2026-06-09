{config, pkgs, inputs, lib, ...}:

# ldac fix
let
  pipewireLdacWorkaround = pkgs.pipewire.overrideAttrs (old: {
    mesonFlags = (old.mesonFlags or [ ]) ++ [
      "-Dbluez5-codec-ldac-dec=disabled"
    ];
  });
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # da bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    limine = {
      enable = true;
      maxGenerations = 30;
      resolution = "2560x1440";
      style = {
        interface.resolution = "2560x1440";
        wallpapers = [
          ./bootloader/nix.png
        ];
      };

    extraEntries = ''
      /Windows
        protocol: efi
        path: uuid(fdfecdc9-7a11-4268-8bbf-7c9b3b919399):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
    };
  };
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Networking & Hostname
  networking = {
    hostName = "12600k-nix"; # Define your hostname.;
    networkmanager = {
      wifi.backend = "wpa_supplicant";
      enable = true;
    };
  };

  # BlueTooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General = {
      Experimental = true;
      Enable = "Souce,Sink,Media,Socket";
    };
  };


  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };


  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "nz";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Pipewire, audio and bluetooth codecs
  security.rtkit.enable = true;
  services.pipewire = {
    package = pipewireLdacWorkaround;
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      package = pkgs.wireplumber.override {
        pipewire = pipewireLdacWorkaround;
      };
    };
    extraConfig.pipewire = {
      "context.modules" = [
        {
          name = "libpipewire-module-bluez5";
          args = {
            "bluez5.codecs" = [
              "sbc"
              "aac"
              "aptx"
              "aptx_hd"
              "ldac"
            ];
          };
        }
      ];
    };
  };


  # User
  users.users.bwopp = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "bwopp";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "render"
    ];
  };


  # Shell
  programs.fish = {
    enable = true;
      interactiveShellInit = ''
        # TokyoNight Storm
        set -g fish_color_normal c0caf5
        set -g fish_color_command 7dcfff
        set -g fish_color_keyword bb9af7
        set -g fish_color_quote e0af68
        set -g fish_color_redirection c0caf5
        set -g fish_color_end ff9e64
        set -g fish_color_option bb9af7
        set -g fish_color_error f7768e
        set -g fish_color_param 9d7cd8
        set -g fish_color_comment 565f89
        set -g fish_color_selection --background=2e3c64
        set -g fish_color_search_match --background=2e3c64
        set -g fish_color_operator 9ece6a
        set -g fish_color_escape bb9af7
        set -g fish_color_autosuggestion 565f89
        set -g fish_pager_color_progress 565f89
        set -g fish_pager_color_prefix 7dcfff
        set -g fish_pager_color_completion c0caf5
        set -g fish_pager_color_description 565f89
        set -g fish_pager_color_selected_background --background=2e3c64
      '';

    shellAliases = {
      ll = "ls -l";
      rebuild = "sudo nixos-rebuild switch";
      update = "sudo nix flake update --flake /etc/nixos/";
      gc = "sudo nix-collect-garbage";
      nixgitpush = "sudo git -C /etc/nixos add . && sudo git -C /etc/nixos commit -m (date '+%Y-%m-%d %H:%M:%S') && sudo git -C /etc/nixos push";
      wup = "warp-cli connect";
      wdown = "warp-cli disconnect";
    };
  };

  users.defaultUserShell = pkgs.fish;

  # Allow unfree packages and firmware
  nixpkgs.config.allowUnfree = true;
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kdePackages.kate
    wget
    prismlauncher
    obsidian
    spotify
    gitFull
    btop
    alacritty
    gparted
    fastfetch
    ffmpeg-full
    mangohud
    legcord
    tailscale
    vlc
    mangohud
    syncthing
    syncthingtray
    protonplus
    gamemode
    javaPackages.compiler.temurin-bin.jre-17
    qbittorrent
    cloudflare-warp
    gamescope
    kdePackages.breeze
    jellyfin-desktop
    proton-authenticator
    element-desktop
    handbrake
    koodo-reader
    balatro-mod-manager
    lact
    protontricks
    spotdl
    picard
    media-downloader
    feishin
    libreoffice-qt
    ollama-rocm
  ];

  # File Sharing
  programs.localsend.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    protontricks.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Warp
  services.cloudflare-warp.enable = true;
  services.cloudflare-warp.openFirewall = true;

  hardware.amdgpu.opencl.enable = true;
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];


  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment? no :|

}
