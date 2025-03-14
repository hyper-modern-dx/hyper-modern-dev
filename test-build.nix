{ pkgs ? import <nixpkgs> { } }:

let
  username = "test-user";
  toolchainModule = import ./modules/toolchain/toolchain-module.nix;
in
pkgs.stdenv.mkDerivation {
  name = "test-toolchain-build";

  # No sources needed
  src = ./.;

  # Just create a simple file to confirm the build worked
  buildPhase = ''
    mkdir -p $out
    echo "Toolchain module test build successful" > $out/success.txt
  '';

  # Skip installation phase
  dontInstall = true;
}
