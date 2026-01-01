{ config, pkgs, ... }:

{
  # Development environment for SecDevOps and Go development

  environment.systemPackages = with pkgs; [
    # Go development
    go
    gopls
    go-tools
    gotools
    golangci-lint
    delve
    gore
    gomodifytags
    gotests
    gocover-cobertura

    # Build tools
    gnumake
    gcc
    cmake
    pkg-config

    # Version control
    git
    git-lfs
    gh
    lazygit

    # Container and virtualization
    docker
    docker-compose
    kubernetes
    kubectl
    k9s
    helm
    kind
    minikube
    podman
    skopeo
    buildah

    # Cloud and infrastructure tools
    terraform
    terragrunt
    packer
    ansible
    vault

    # Network tools
    dig
    whois
    traceroute
    mtr
    iperf
    iproute2

    # Monitoring and observability
    prometheus
    grafana
    loki
    promtail

    # CI/CD
    jenkins
    gitlab-runner

    # Text editors and IDEs
    neovim
    vscode

    # Terminal utilities
    tmux
    screen
    zsh
    oh-my-zsh
    fzf
    ripgrep
    fd
    bat
    exa
    delta

    # JSON/YAML tools
    jq
    yq-go

    # Scripting
    python311
    python311Packages.pip
    python311Packages.virtualenv
    nodejs_20
    nodePackages.npm

    # API testing
    postman
    httpie
    curl

    # Database tools
    postgresql
    redis
    sqlite

    # Linters and formatters
    shellcheck
    shfmt
    yamllint
    hadolint
    trivy

    # Secrets management
    sops
    age
    gnupg

    # Documentation
    pandoc
    graphviz
  ];

  # Docker configuration
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Podman configuration
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Enable libvirt for VMs
  virtualisation.libvirtd.enable = true;

  # Development-friendly shell
  programs.zsh.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      pull.rebase = true;
      fetch.prune = true;
    };
  };

  # Enable direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Environment variables for Go
  environment.variables = {
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    GO111MODULE = "on";
  };

  # Add Go bin to PATH
  environment.sessionVariables = {
    PATH = [ "$HOME/go/bin" ];
  };
}
