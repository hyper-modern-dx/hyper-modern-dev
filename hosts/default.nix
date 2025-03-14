{ inputs, config, ... }:
{
  watchtower = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "aarch64-linux";

    modules = [
      ./nixos-common.nix
      ./watchtower/configuration.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix

      # Home-manager configuration for users
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;

          users.b7r6 = { ... }: {
            imports = [
              # Import the toolchain module through home
              config.flake.homeManagerModules.home.nixosGUI
              # User-specific customizations would go here
              {
                home = {
                  username = "b7r6";
                  homeDirectory = "/home/b7r6";
                  stateVersion = "24.11";
                };
              }
            ];
          };

          users.maskirov = { ... }: {
            imports = [
              # Import the toolchain module through home
              config.flake.homeManagerModules.home.nixosGUI
              # User-specific customizations would go here
              {
                home = {
                  username = "maskirov";
                  homeDirectory = "/home/maskirov";
                  stateVersion = "24.11";
                };

                programs.git = {
                  enable = true;
                  userName = "maskirov";
                  userEmail = "maskirov@xz.team";
                };
              }
            ];
          };
        };
      }
    ];
  };
}
