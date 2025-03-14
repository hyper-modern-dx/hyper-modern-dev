{ pkgs ? import <nixpkgs> { } }:

let
  home = {
    username = "test-user";
    homeDirectory = "/home/test-user";
  };
in
import ../modules/toolchain/toolchain-module.nix {
  config = { inherit home; };
  lib = pkgs.lib;
  pkgs = pkgs;
  currentSystem = "linux";
  withGUI = false;
}
