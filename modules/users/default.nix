{ config, pkgs, ... }:

{
  # User management module
  # DO NOT commit actual usernames or SSH keys to this public repo
  # Override these values in your host-specific configuration

  options = {
    # Define options that can be overridden per host
  };

  config = {
    # Default user configuration template
    # This should be overridden in host-specific configs

    # Example user configuration (commented out for security)
    # users.users.youruser = {
    #   isNormalUser = true;
    #   description = "Your Name";
    #   extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    #   shell = pkgs.zsh;
    #   # DO NOT add openssh.authorizedKeys here in a public repo
    #   # Add them in your private host-specific configuration or use a secrets manager
    # };

    # Ensure wheel group can use sudo
    security.sudo.wheelNeedsPassword = true;

    # Sudo timeout
    security.sudo.extraConfig = ''
      Defaults        timestamp_timeout=15
    '';
  };
}
