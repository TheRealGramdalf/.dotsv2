{ config, pkgs, lib, ... }:

{  
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  home = {
    username = "gramdalf";
    homeDirectory = "/home/gramdalf";
    stateVersion = "23.05";
    
    shellAliases = {
      lla = "ls -la";
      scf = "sudo nano ~/nix/system/configuration.nix &&
            var=$(pwd) &&
            cd ~/nix &&
            git add -A &&
            git commit -m 'Push local changes' &&
            cd $var";
      srb = "sudo nixos-rebuild switch --flake ~/nix/system#aerwiar";
      srbb = "sudo nixos-rebuild boot --flake ~/nix/system#aerwiar";
      hcf = "nano ~/nix/home/home.nix && pushd ~/nix && git add -A && git commit -m 'Push local changes' && popd ";
      hrb = "home-manager switch --flake ~/nix/home#gramdalf";
      gp = "var=$(pwd) && cd ~/nix && git add -A && git commit -m 'Push local repo' && git push && cd $var";
      speedtest = "speedtest-cli";
      provides = "nix-locate -w";
      isfs = "dir=$1 sudo mkdir -p /tmp/isfs && sudo mount $dir /tmp/isfs && sudo tree -d 2 /tmp/isfs | tr -d '/tmp/isfs' && sudo umount $dir";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
      MOZ_ENABLE_WAYLAND = "1";
      QT_STYLE_OVERRIDE = "adwaita";
      QT_QPA_PLATFORMTHEME = "gnome";
    };
    packages = with pkgs; [
      #### GUI ####

      # Shell/terminal
      blackbox-terminal
      zsh
      zsh-autosuggestions
      gnome-terminal
      # Communication
      webcord
      electron-mail
      jitsi
      zoom
      chatterino2
      # Word Processing
      libreoffice
      onlyoffice-bin # For improved compatibility over libreoffice
      vscodium
      obsidian
      # Services
      bitwarden
      denaro
      celeste
      kodi-wayland
      jellyfin-web
      pika-backup
      protonvpn-gui
      nextcloud-client
      newsflash # RSS feed reader
      # File editors
      audacity
      pitivi # Video editor
      blender
      gimp
      calibre
      # Utilities
      gnome.gnome-calculator
      gnome.gnome-system-monitor
      gnome.gnome-sound-recorder
      gnome-obfuscate
      baobab # Disk usage analyzer
      gnome.gnome-disk-utility
      whatip
      gnome-solanum # Pomodoro timer
      eartag # File tag editor
      evince # Document viewer
      gcolor3 # Color picker
      clapper # Video viewer
      gnome.eog # Photo viewer
      gnome.gnome-power-manager # Battery stats
      textpieces # Manipulate text without random websites
      dialect # Translate app
      iotas # MD notes app
      drawing
      vlc
      gnome.gnome-clocks
      gnome.gnome-logs
      gnome.gnome-maps
      gnome.gnome-characters # Emojis and other chars
      gnome.nautilus
      gnome.simple-scan
      #gnome-connections
      gnome-secrets
      gnome.gnome-font-viewer
      obs-studio
      # Partition tools
      gparted
      rpi-imager
      # Settings
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome-extension-manager
      # Web browsers
      librewolf
      brave
      epiphany
      qbittorrent
      # Hypervisors
      bottles      
      # Games
      prismlauncher
      steam
      mangohud # System usage stats
      #### Theming ####
      adwaita-qt6
      adwaita-qt
      qgnomeplatform
      qgnomeplatform-qt6
      gradience
      #### CLI ####
      cmatrix
      android-tools
      speedtest-cli
      unzip
      nix-index
      gh
      git
      gitg
      youtube-tui
      btrbk
      plocate
      neofetch
      tealdeer
      ventoy-full
      firehol
      iperf3
      dmidecode
      usbutils
      pciutils
      smartmontools
      ffmpeg_6-full
      traceroute
      nmap
      arp-scan
      tree
      #### Libraries/Drivers ####
      # Misc
      libva-utils
      ntfs3g
      # Fonts
      andika
      # Asus ROG drivers
      asusctl
      # DGPU utils
      supergfxctl
      # Gnome Extensions
      gnomeExtensions.supergfxctl-gex
      gnomeExtensions.pop-shell
      gnomeExtensions.vitals
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.espresso
      #gnomeExtensions.ddterm
      # ddterm dependencies
      gjs
      vte
    ];
  };
  # VScodium configuration
  programs.vscode = {
  enable = true;
  package = pkgs.vscodium;
  extensions = with pkgs.vscode-extensions; [
    # VSCodium Extensions
    arrterian.nix-env-selector
    #mkhl.direnv
    piousdeer.adwaita-theme
    jnoortheen.nix-ide
  ];
};
  
  programs = {
    home-manager.enable = true;
    bash.enable = true;

    
    git = {
      enable = true;
      userEmail = "gramdalftech@gmail.com";
      userName = "TheRealGramdalf";
    };
    mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };
  
  # Requires a full reboot for dark mode to take effect
  gtk = {
    enable = true;
    
    theme = {
      name = "Adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = "0";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = "0";
    };
  };
  
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = lib.mkForce "adw-gtk3-dark";
      enable-hot-corners = false;
      gtk-enable-primary-paste = "false";
      clock-format = "12h";
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = ["disabled"];
      switch-applications-backward = ["disabled"];
      switch-windows = ["<Alt>Tab"];
      switch-windows-backward = ["<Shift><Alt>Tab"];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
      show-create-link = true;
      show-delete-permanently = true;
      clock-format = "12h";
    };
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      sort-directories-first = true;
      show-delete-permanently = true;
    };
    /*
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };
    */
    # Extensions
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "disabled"
      ];
      enabled-extensions = [
        "pop-shell@system76.com"
        "Vitals@CoreCoding.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "ddterm@amezin.github.com"
        "supergfxctl-gex@asus-linux.org"
        "espresso@coadmunkee.github.com"
      ];
    };
    /*
    "org/gnome/shell/extensions" = {
      vitals = {
        #show-battery = true;
        #hot-sensors = ["'_memory_usage_', '_processor_usage_', '_battery_state_', '_battery_rate_'"];
      };
    };
    */
    "org/gnome/shell/extensions/espresso" = {
      show-notifications = false;
    }; 
  };
}
