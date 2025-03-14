# Comprehensive toolchain module that consolidates development tools
{ config, lib, pkgs, currentSystem ? "linux", withGUI ? false, ... }:

let
  # Default values for user info - safely access home attributes if they exist
  defaultUsername = "default";
  defaultEmail = "user@example.com";
  defaultHomeDirectory =
    if currentSystem == "darwin" then "/Users/${defaultUsername}"
    else "/home/${defaultUsername}";

  # Get username and homeDirectory safely
  username =
    if config ? home && config.home ? username
    then config.home.username
    else defaultUsername;

  homeDirectory =
    if config ? home && config.home ? homeDirectory
    then config.home.homeDirectory
    else if currentSystem == "darwin"
    then "/Users/${username}"
    else "/home/${username}";

  userInfo = {
    inherit username;
    inherit homeDirectory;
    email = defaultEmail;
  };
in
{
  # Import specialized toolchain components
  imports = [
    ./atuin-toolchain.nix
    ./bash-toolchain.nix
    ./emacs-toolchain.nix
    ./ghostty-toolchain.nix
    ./starship-toolchain.nix
    ./stylix-toolchain.nix
    ./tmux-toolchain.nix
    ./wezterm-toolchain.nix
  ];

  # Create a test file that shows the toolchain was successfully activated
  home.file.".toolchain-test" = {
    text = ''
      TOOLCHAIN_ACTIVATED=true
      SYSTEM=${currentSystem}
      GUI=${toString withGUI}
      USER=${userInfo.username}
      HOME=${userInfo.homeDirectory}
      EMAIL=${userInfo.email}
      DATE=$(date +"%Y-%m-%d")
    '';
  };

  # Make sure home.username and homeDirectory are set if provided
  home.username = lib.mkDefault userInfo.username;
  home.homeDirectory = lib.mkDefault userInfo.homeDirectory;

  # Core CLI utilities
  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # Git configuration with user details
  programs.git = lib.mkIf (config.programs.git.enable or true) {
    userName = lib.mkDefault userInfo.username;
    userEmail = lib.mkDefault userInfo.email;
  };

  # Consolidated development tools
  home.packages = with pkgs; [
    # Core CLI utilities
    btop
    direnv
    duf
    dust
    fd
    glow
    htop
    jq
    ripgrep
    viddy
    vivid

    # Development essentials
    gh
    just
    openssl
    openssl.dev
    pkg-config
    treefmt
    tree-sitter

    # Nix development
    nixd
    nixpkgs-fmt
    statix

    # Python development
    uv
    ruff
    (python313.withPackages (ps: [ ps.llm ps.llm-anthropic ]))

    # File format tools
    taplo
    toml-sort
    hclfmt

    # Cloud tools
    awscli2
    google-cloud-sdk-gce
    hcp
    terraform
    terragrunt
    vault-bin

    # Shell scripting
    shellcheck
    shfmt

    # Web development
    biome
    nodePackages_latest.nodejs
    nodePackages_latest.prettier
    nodePackages_latest.typescript-language-server
    nodePackages_latest.yarn
    typescript
    bun

    # Systems programming
    clang-tools_19
    gcc
    gnumake
    zig
    zls

    # Ruby
    rubocop
    ruby_3_1
    solargraph

    # AI tools
    claude-code
  ] ++ lib.optionals withGUI [
    # GUI tools if enabled
    xclip
    wl-clipboard
  ];
}
