{ config
, lib
, pkgs
, ...
}:
{
  # Default user configuration that applies to all users
  # Individual users can override these defaults in their specific config

  # Common modules for all users
  imports = [
    # ../../atuin      # Atuin moved to toolchain module
    # ../../bash       # Bash moved to toolchain module
    # ../../emacs      # Emacs moved to toolchain module
    # ../../ghostty    # Ghostty moved to toolchain module
    ../../git
    # ../../starship   # Starship moved to toolchain module
    # ../../tmux       # Tmux moved to toolchain module
    # ../../cli        # CLI tools moved to toolchain module
    # ../../toolchains # Development tools moved to toolchain module
    # ../../wezterm    # WezTerm moved to toolchain module
  ];

  # Home Manager default configuration
  programs.home-manager.enable = true;

  # Default state version
  # This should be kept at the release version when first installed
  home.stateVersion = "24.11";
}
