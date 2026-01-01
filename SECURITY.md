# Security Guidelines

This repository contains NixOS configurations for development machines. Since this is a **public repository**, follow these security best practices:

## DO NOT Commit

- **SSH Keys**: Never commit private or public SSH keys
- **Usernames**: Avoid committing real usernames
- **Passwords**: Never commit passwords or password hashes
- **API Keys/Tokens**: Never commit any credentials
- **Private Network Info**: IP addresses, VPN configs, etc.
- **Hardware Serial Numbers**: May be in hardware configs

## Recommended Practices

### 1. Use Secrets Management

Consider using [sops-nix](https://github.com/Mic92/sops-nix) for managing secrets:

```nix
# In your flake.nix inputs:
sops-nix.url = "github:Mic92/sops-nix";
```

### 2. Private Configuration Overlay

Create a private git repository for sensitive overrides:

```bash
# In your NixOS system
git clone git@private-repo:your-secrets.git /etc/nixos/private
```

Then import in your configuration:
```nix
imports = [
  /etc/nixos/private/secrets.nix
];
```

### 3. Environment-Specific Configurations

Keep environment-specific details in separate files that are not committed:

```nix
# local.nix (gitignored)
{
  users.users.realusername = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAA..."
    ];
  };
}
```

### 4. Hardware Configurations

While hardware-configuration.nix typically doesn't contain secrets, it may reveal:
- Hardware models
- Disk UUIDs
- System capabilities

Consider if you want these public.

### 5. SSH Key Management

**Never** add SSH keys in this public repo. Instead:

**Option A**: Manual deployment after install
```bash
ssh-copy-id youruser@dev-machine-1
```

**Option B**: Use sops-nix or age encryption
```nix
# Encrypted with sops
users.users.youruser.openssh.authorizedKeys.keys = [
  (builtins.readFile ./secrets/ssh-keys/youruser.pub)
];
```

**Option C**: Fetch from secure source during build
```nix
openssh.authorizedKeys.keyFiles = [
  (pkgs.fetchurl {
    url = "https://github.com/yourusername.keys";
    sha256 = "...";
  })
];
```

## Security Hardening Checklist

- [ ] Change default usernames in host configurations
- [ ] Generate unique SSH host keys per machine
- [ ] Configure firewall rules for your specific needs
- [ ] Review and customize kernel hardening parameters
- [ ] Set appropriate timezone (not UTC if not needed)
- [ ] Enable automatic security updates (if desired)
- [ ] Configure fail2ban for SSH protection
- [ ] Review AppArmor profiles
- [ ] Set up regular backups of critical data
- [ ] Document your network topology privately
- [ ] Use strong, unique passwords for user accounts
- [ ] Enable disk encryption (configure in hardware-configuration.nix)

## Incident Response

If you accidentally commit sensitive data:

1. **Immediately rotate all exposed credentials**
2. **Remove from Git history**:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/sensitive/file" \
     --prune-empty --tag-name-filter cat -- --all

   git push origin --force --all
   ```
3. **Consider the data permanently compromised**
4. **Review git history for other potential leaks**

## Security Contacts

For security issues with this configuration:
- Open an issue (for non-sensitive matters)
- Contact privately for sensitive security concerns

## Regular Security Audits

Run these tools periodically:

```bash
# Lynis security audit
sudo lynis audit system

# RKHunter for rootkits
sudo rkhunter --check

# AIDE for file integrity
sudo aide --check
```

## Additional Resources

- [NixOS Security](https://nixos.org/manual/nixos/stable/#sec-security)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
