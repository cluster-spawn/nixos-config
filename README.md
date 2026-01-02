# NixOS Configuration for SecDevOps Development

A modular, secure NixOS configuration designed for SecDevOps engineers with Go development requirements. This configuration supports multiple machines with shared modules for consistency and maintainability.

## Features

- **Modular Architecture**: Reusable modules for common, security, development, and user configurations
- **Security Hardened**: SSH hardening, firewall, fail2ban, kernel hardening, AppArmor, audit system
- **SecDevOps Tools**: Complete toolkit for security operations, penetration testing, and DevOps
- **Go Development**: Full Go development environment with tools and utilities
- **Container Support**: Docker, Podman, and Kubernetes tools
- **Infrastructure as Code**: Terraform, Ansible, Packer, and cloud tools
- **Flake-based**: Modern Nix flakes for reproducible builds

## Structure

```
nixos-config/
├── flake.nix                    # Main flake configuration
├── hosts/
│   ├── dev-machine-1/
│   │   ├── configuration.nix    # Host-specific config
│   │   └── hardware-configuration.nix
│   └── dev-machine-2/
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── modules/
    ├── common/                  # Base system configuration
    ├── security/                # Security hardening
    ├── development/             # Dev tools and environments
    └── users/                   # User management
```

## Security Notice

**This is a PUBLIC repository.** Read [SECURITY.md](./SECURITY.md) carefully before using.

**DO NOT commit:**
- SSH keys
- Real usernames
- Passwords or tokens
- Private network configurations
- Any sensitive data

## Quick Start

### 1. Initial Setup

Clone this repository:
```bash
git clone https://github.com/yourusername/nixos-config.git
cd nixos-config
```

### 2. Generate Hardware Configuration

On your target machine, generate the hardware configuration:
```bash
sudo nixos-generate-config --show-hardware-config > hosts/dev-machine-1/hardware-configuration.nix
```

### 3. Customize Configuration

Edit `hosts/dev-machine-1/configuration.nix`:
- Replace `youruser` with your actual username
- Update timezone in `modules/common/default.nix`
- Configure firewall ports as needed
- Review security settings

**IMPORTANT**: DO NOT commit your customizations with sensitive data. Use a private overlay or secrets management.

### 4. Build and Test

Test the configuration:
```bash
sudo nixos-rebuild test --flake .#dev-machine-1
```

### 5. Apply Configuration

Apply permanently:
```bash
sudo nixos-rebuild switch --flake .#dev-machine-1
```

## Included Tools

### Go Development
- Go compiler and runtime
- gopls (language server)
- golangci-lint, delve (debugger)
- Various Go tools and utilities

### Container & Orchestration
- Docker & Docker Compose
- Podman, Buildah, Skopeo
- Kubernetes: kubectl, helm, k9s, kind, minikube

### Infrastructure as Code
- Terraform & Terragrunt
- Ansible
- Packer
- Vault & Consul

### Development Tools
- Git, GitHub CLI, LazyGit
- Neovim, VSCode
- Python, Node.js
- Database: PostgreSQL, Redis, SQLite

## Usage

### Managing Multiple Machines

Build for specific machine:
```bash
sudo nixos-rebuild switch --flake .#dev-machine-1
sudo nixos-rebuild switch --flake .#dev-machine-2
```

### Adding a New Machine

1. Create new host directory:
```bash
mkdir -p hosts/dev-machine-3
```

2. Create configuration files:
```bash
cp hosts/dev-machine-1/configuration.nix hosts/dev-machine-3/
# Generate hardware config on target machine
```

3. Add to `flake.nix`:
```nix
dev-machine-3 = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/dev-machine-3/configuration.nix
    ./hosts/dev-machine-3/hardware-configuration.nix
    # ... other modules
  ];
};
```

### Updating the System

Update flake inputs:
```bash
nix flake update
```

Rebuild with updates:
```bash
sudo nixos-rebuild switch --flake .#dev-machine-1
```

### Adding Packages

**Per-host packages**: Edit `hosts/dev-machine-1/configuration.nix`
```nix
environment.systemPackages = with pkgs; [
  your-package
];
```

**Shared packages**: Edit appropriate module in `modules/`

### Customizing Modules

Modules are designed to be reusable. To customize:

1. **For all machines**: Edit the module in `modules/`
2. **For specific machine**: Override in host configuration
3. **For sensitive configs**: Use private overlay (not committed)

## Security Hardening

This configuration includes:

- SSH: Key-only auth, no root login, connection limits
- Firewall: Enabled by default with minimal open ports
- Fail2ban: Automatic ban after failed auth attempts
- Kernel hardening: SYN flood protection, ICMP disabled, etc.
- AppArmor: Mandatory access control
- Audit system: System call monitoring
- Secure boot: Systemd-boot with EFI
- Automatic garbage collection: Cleanup old generations

Review and customize in [modules/security/default.nix](./modules/security/default.nix)

## Secrets Management

For managing secrets, consider:

1. **sops-nix**: Encrypt secrets with age/PGP
2. **Private Git repo**: Separate private configuration overlay
3. **Vault**: HashiCorp Vault for runtime secrets
4. **Manual**: Add sensitive configs manually after deployment

See [SECURITY.md](./SECURITY.md) for detailed guidance.

## Development Workflows

### Go Development

Go environment is pre-configured:
```bash
# GOPATH and GOBIN are set
echo $GOPATH  # ~/go
echo $GOBIN   # ~/go/bin

# Create new project
mkdir ~/projects/myapp && cd ~/projects/myapp
go mod init github.com/username/myapp
```

### Container Development

Docker and Podman are enabled:
```bash
docker run hello-world
podman run hello-world
```

### Kubernetes Local Development

Use kind or minikube:
```bash
kind create cluster
kubectl cluster-info
```

## Troubleshooting

### Build Fails

```bash
# Check syntax
nix flake check

# Verbose output
sudo nixos-rebuild switch --flake .#dev-machine-1 --show-trace
```

### Rollback

```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback
sudo nixos-rebuild switch --rollback
```

### Clean Up

```bash
# Remove old generations
sudo nix-collect-garbage -d

# Optimize store
sudo nix-store --optimize
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes (ensure no sensitive data)
4. Test on a local machine
5. Submit pull request

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [Home Manager](https://github.com/nix-community/home-manager)
- [NixOS Security](https://nixos.org/manual/nixos/stable/#sec-security)

## License

See [LICENSE](./LICENSE) file.

## Support

- Issues: GitHub Issues
- Discussions: GitHub Discussions
- NixOS Community: [Discourse](https://discourse.nixos.org/)

---

**Remember**: This is a public repository. Never commit sensitive information. Review [SECURITY.md](./SECURITY.md) regularly.
