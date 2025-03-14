{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../toolchain/toolchain-module.nix
  ];

  # Set environment variables for the toolchain module
  _module.args = {
    withGUI = true;
    currentSystem = "darwin";
  };
}
