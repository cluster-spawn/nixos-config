{ config, pkgs, ... }:

{
  # Security hardening for SecDevOps environments

  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = false;
    # Add specific ports as needed per host
    # allowedTCPPorts = [ ];
    # allowedUDPPorts = [ ];
  };

  # SSH hardening
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
    # Only allow key-based authentication
    extraConfig = ''
      AllowUsers *@*
      MaxAuthTries 3
      MaxSessions 5
      ClientAliveInterval 300
      ClientAliveCountMax 2
    '';
  };

  # Fail2ban for SSH protection
  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
  };

  # Kernel hardening
  boot.kernel.sysctl = {
    # IP forwarding (disable if not needed)
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.forwarding" = 0;

    # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_syn_retries" = 2;
    "net.ipv4.tcp_synack_retries" = 2;
    "net.ipv4.tcp_max_syn_backlog" = 4096;

    # Disable ICMP redirects
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;

    # Disable send redirects
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;

    # Enable source route verification
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;

    # Ignore ICMP ping requests
    "net.ipv4.icmp_echo_ignore_all" = 1;

    # Protect against time-wait assassination
    "net.ipv4.tcp_rfc1337" = 1;
  };

  # Audit system
  security.auditd.enable = true;
  security.audit.enable = true;
  security.audit.rules = [
    "-a exit,always -F arch=b64 -S execve"
  ];

  # AppArmor for mandatory access control
  security.apparmor.enable = true;

  # Disable coredumps
  systemd.coredumps.enable = false;

  # Secure shared memory
  boot.tmp.useTmpfs = true;

  # Additional security packages
  environment.systemPackages = with pkgs; [
    clamav
    rkhunter
    lynis
    aide
  ];

  # Automatic security updates (optional, configure per host)
  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false;
  #   channel = "https://nixos.org/channels/nixos-unstable";
  # };
}
