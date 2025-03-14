#!/usr/bin/env bash
set -e

# Create test directory
mkdir -p .test-toolchain

# Create a test Nix expression
cat >.test-toolchain/test.nix <<'EOF'
{ pkgs ? import <nixpkgs> {} }:

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
EOF

# Test if the module can be instantiated
echo "Evaluating toolchain module..."
nix-instantiate -E "with import <nixpkgs> {}; callPackage ./.test-toolchain/test.nix {}"
echo "Test passed! ✓"
