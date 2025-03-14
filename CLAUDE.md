# Hyper-Modern Nix Configuration Guidelines

## Essential Commands

- Build: `sudo nixos-rebuild switch --flake .#watchtower` - Update specific host
- Home-manager: `home-manager switch` - Apply user configuration
- Format: `treefmt` - Format all code per language conventions
- Test: `just test` - Run toolchain module tests
- Update: `nix flake update` - Update flake inputs
- Dev Shell: `nix develop` - Enter development environment

## Code Style

- **Formatting**: Automated with `treefmt` which uses:
  - Nix: `nixpkgs-fmt` - 2 spaces, 80 column limit
  - Python: `ruff format` - PEP 8 guidelines, black-compatible
  - Shell: `shfmt -i 2` - 2 space indentation
  - JS/TS: `biome` - Modern unified formatter
- **Naming Conventions**:
  - Use camelCase for variable and function names in Nix
  - Prefer descriptive names over abbreviations
  - Use module-based organization for related functionality
- **Organization**:
  - Host-specific configs in `hosts/{hostname}/`
  - User configs in `modules/common/users/{username}/`
  - System user definitions in `hosts/nixos-common.nix`
  - Always put new modules in appropriate subdirectories

## Repository Structure

- `flake.nix` - Main entrypoint with inputs and outputs
- `modules/` - Shared configuration modules (common, nixos, home, darwin)
- `hosts/` - Host-specific configurations
- Cross-platform support: Linux (x86_64/aarch64) and Darwin (aarch64)
- Tools: nixd (LSP), ruff (Python), biome (JS/TS), stylix (theming)

When adding new features, ensure cross-platform compatibility and adhere to the established modular architecture.
