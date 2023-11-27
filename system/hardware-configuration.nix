# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."enc_rootfs" = {
    device = "/dev/disk/by-uuid/df613695-9423-4abf-bfab-8b90974b9c43";
    bypassWorkqueues = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/nix_rootfs";
      fsType = "btrfs";
      options = [ "subvol=nix_root" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/nix_rootfs";
      fsType = "btrfs";
      options = [ "subvol=nix_home" ];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-label/nix_rootfs";
      fsType = "btrfs";
      options = [ "subvol=nix_var" ];
    };
/*
  fileSystems."/persist" =
    { device = "/dev/disk/by-label/nix_rootfs";
      fsType = "btrfs";
      options = [ "subvol=nix_persist" ];
    };
*/
  fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIX_BOOTFS";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/nix_rootfs";
      fsType = "btrfs";
      options = [ "subvol=nix_store" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp2s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
