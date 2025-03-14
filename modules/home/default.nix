{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = lib.mkDefault "maskirov";
  home.homeDirectory = lib.mkDefault "/home/maskirov";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # Enable Home Manager
  programs.home-manager.enable = true;

  # Allow unfree packages (like Terraform)
  nixpkgs.config.allowUnfree = true;
}
