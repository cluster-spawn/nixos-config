# This is a placeholder hardware configuration file
# You MUST generate your actual hardware configuration by running:
# sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
# on your target machine

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # PLACEHOLDER - Replace with actual hardware configuration
  # boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  # boot.initrd.kernelModules = [ ];
  # boot.kernelModules = [ "kvm-intel" ];
  # boot.extraModulePackages = [ ];

  # fileSystems."/" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
  #   fsType = "ext4";
  # };

  # fileSystems."/boot" = {
  #   device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
  #   fsType = "vfat";
  # };

  # swapDevices = [ ];

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
