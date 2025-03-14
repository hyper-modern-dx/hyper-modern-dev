{ pkgs ? import <nixpkgs> { } }:
pkgs.lib.evalModules {
  modules = [
    ({ ... }: {
      imports = [ ../modules/toolchain/toolchain-module.nix ];
      _module.args = {
        pkgs = pkgs;
        lib = pkgs.lib;
        currentSystem = "linux";
        withGUI = false;
      };
      home = {
        username = "test-user";
        homeDirectory = if "linux" == "darwin" then "/Users/test-user" else "/home/test-user";
        stateVersion = "24.11";
      };
      programs.git = {
        enable = true;
        userEmail = "test@example.com";
      };
    })
  ];
}
