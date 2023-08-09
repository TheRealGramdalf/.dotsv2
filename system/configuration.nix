# Help is available in the configuration.nix(5) man page.
# Edit hardware-configuration.nix as well
 
{ config, lib, modulesPath, pkgs, ... }:
 
{
  imports = [  ];
  
  boot = {
    plymouth.enable = true;
    tmp.cleanOnBoot = true;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
    loader = {
      systemd-boot.enable = true;
    };
  };

  hardware = {    
    pulseaudio.enable = false;
    
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      ];
    };
  };
  
  powerManagement = {
    enable = true;
    scsiLinkPolicy = "med_power_with_dipm";
  };
  
  system = {
    stateVersion = "unstable";
    
    autoUpgrade = {
      enable = false;
      allowReboot = false;
      operation = "boot";
      dates = "daily";
      persistent = false;
    };
  };
  
  console = {
    font = "ter-v24b";
    keyMap = "us";
  };
  
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "19:10";
      options = "--delete-older-than 3d";
    };

    settings = {
      auto-optimise-store = true;
      
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
  
    config = {
      allowUnfree = true;
    
      packageOverrides = in_pkgs : {
        linuxPackages = in_pkgs.linuxPackages_latest;
      };
    };
  };
  
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Africa/Douala";

  networking = {
    hostName = "aerwiar";
    hostId = "16a85224";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    nameservers = [ "1.1.1.3, 1.0.0.3" ];
    
    firewall = {
      enable = false;
      logRefusedConnections = true;
    };
  };
  # Temporary patch for supergfxd. Will be merged in a future release.
  systemd.services.supergfxd.path = [ pkgs.pciutils ];
  services = {
    fwupd.enable = true;
    thermald.enable = true;
    locate.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    # For Asus ROG laptops
    supergfxd = {
      enable = true;
    };
    asusd = {
      enable = true;
      enableUserService = true;
    };
    # nvidia sleep service
    #nvidia-powerd.enable = true;
    gnome = {
      gnome-keyring.enable = true;
      core-utilities.enable = false;
    };
    
    xserver = {
      videoDrivers = [ "nvidia" ];
      enable = true;
      layout = "us";
      # libinput.enable = true;
      excludePackages = [ pkgs.xterm ];
      
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
      };

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
  
  environment = {

    systemPackages = with pkgs; [ ];

    gnome.excludePackages = with pkgs; [
      gnome-tour
    ];
  };
  
  # Docker
  virtualisation.docker.enable = false;
  virtualisation.docker.storageDriver = "btrfs";

  users = {
    mutableUsers = false;
    
    users.gramdalf = {
      isNormalUser = true;
      description = "Gramdalf";
      extraGroups = [ "wheel" "networkmanager" "docker"];
      passwordFile = "/etc/passwdfile.gramdalf";
      
      packages = with pkgs; [
        home-manager
        git
        vim
        wget
        curl
     ];
    };
  };    
}
