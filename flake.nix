{
  description = "Personal NixOS configuration with multi-platform support";

  inputs = {
    # Core dependencies
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake infrastructure
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin support
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Formatting & themes
    treefmt-nix.url = "github:numtide/treefmt-nix";
    stylix.url = "github:danth/stylix";

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Emacs package management
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { flake-parts, nixpkgs, home-manager, ... }:
    let
      # Function to create a home-manager configuration
      mkHomeConfig = { username, system, extraModules ? [ ] }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          modules = [
            # Base home-manager module
            ./modules/home/default.nix

            # Include toolchain module
            ./modules/toolchain/toolchain-module.nix

            # Stylix theme support
            inputs.stylix.homeManagerModules.stylix

            # User info
            {
              home = {
                inherit username;
                homeDirectory =
                  if (builtins.match ".*darwin" system != null)
                  then "/Users/${username}"
                  else "/home/${username}";
                stateVersion = "24.11";
              };
            }
          ] ++ extraModules;

          extraSpecialArgs = {
            inherit inputs;
            currentSystem = if (builtins.match ".*darwin" system != null) then "darwin" else "linux";
          };
        };

      # Home configurations for direct use with home-manager
      homeConfigurations = {
        "maskirov@watchtower" = mkHomeConfig {
          username = "maskirov";
          system = "x86_64-linux";
          extraModules = [
            {
              # User-specific customizations
              programs.git = {
                enable = true;
                userName = "maskirov";
                userEmail = "maskirov@xz.team";
              };

              # Enable GUI tools
              _module.args.withGUI = true;
            }
          ];
        };
      };

      # Main flake outputs using flake-parts
      flakeOutputs = flake-parts.lib.mkFlake { inherit inputs; } {
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
        ];

        imports = [
          inputs.treefmt-nix.flakeModule
          ./modules/nixos
          ./modules/darwin
          ./modules/common
          # Don't import home module here, as it's used directly in homeConfigurations
        ];

        perSystem = { config, self', pkgs, lib, system, ... }: {
          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              nixpkgs-fmt.enable = true;
              prettier.enable = true;
              black.enable = true;
              shfmt.enable = true;
            };
          };

          # Custom packages available on all systems
          packages = {
            # Custom Emacs build with eask
            custom-emacs = import ./pkgs/emacs { inherit pkgs; };
          };

          # Development shell with useful tools
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              sops
              age
              ssh-to-age
              nixpkgs-fmt
              treefmt
              nixd
            ];
          };

          # Make system available to modules that need it
          _module.args.currentSystem = system;
        };
      };
    in
    # Combine flake-parts outputs with direct homeConfigurations
    flakeOutputs // { inherit homeConfigurations; };
}
