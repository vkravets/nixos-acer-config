# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  ...
}:

{
  nixpkgs = {
    # You can add overlays here
    # overlays = [ ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader.

  boot = {

    # Plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "i915.fastboot=1"
    ];

    loader = {

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
      };

      grub = {
        efiSupport = true;
        #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
        device = "nodev";
      };

      grub2-theme = {
        enable = true;
        theme = "vimix";
        footer = true;
      };
    };
  };

  console = {
    font = "ter-132n";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  services.logrotate.checkConfig = false;

  # TTY
  fonts.packages = with pkgs; [ meslo-lgs-nf ];
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-name=MesloLGS NF
      font-size=14
    '';
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "us,ua,ru";
    };
  };

  services.gnome.gnome-browser-connector.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  services.flatpak.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.easynix = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "easynix";
    extraGroups = [
      "networkmanager"
      "wheel"
      "flatpak"
    ];
    packages = with pkgs; [
      firefox
      kitty
      #  thunderbird
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      easynix = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    mc
    htop
    pciutils
    wget
    curl
    nix-output-monitor
    choose
    home-manager
    unzip
    uftpd
  ];

  programs = {
    fish = {
      enable = true;
    };

    command-not-found = {
      enable = false;
    };

    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];

  # Enable 69 port for tftp
  networking.firewall.allowedUDPPorts = [ 69 ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  system.activationScripts.diff = ''
    if [[ -e /run/current-system ]]; then
      echo -e "\n***            ***          ***           ***           ***\n"
      ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig" | grep -w "→" | grep -w "KiB" | column --table --separator " ,:" | ${pkgs.choose}/bin/choose 0:1 -4:-1 | ${pkgs.gawk}/bin/awk '{s=$0; gsub(/\033\[[ -?]*[@-~]/,"",s); print s "\t" $0}' | sort -k5,5gr | ${pkgs.choose}/bin/choose 6:-1 | column --table
      echo -e "\n***            ***          ***           ***           ***\n"
    fi
  '';
}
