# Bash configuration for toolchain module
{ config, lib, pkgs, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.bash = {
    enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch";
      update-flake = "nix flake update && sudo nixos-rebuild switch";
    };

    historyControl = [ "ignoredups" "erasedups" ];
    historyFileSize = 10000;
    historySize = 10000;

    sessionVariables = {
      EDITOR = "nvim";
    };

    initExtra = ''
      export TERM=xterm-256color
      export COLORTERM=truecolor
      export COLORFGBG="15;0"

      # Make sure local bin is in path
      export PATH="$HOME/.local/bin:$PATH"
      
      # Common prompt style if starship isn't active
      PS1='\[\033[1;36m\]\u\[\033[1;37m\]@\[\033[1;32m\]\h\[\033[1;37m\]:\[\033[1;34m\]\w\[\033[0m\]\$ '
    '';
  };
}
