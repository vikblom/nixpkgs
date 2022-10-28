{ config, pkgs, ... }:

# https://nix-community.github.io/home-manager/index.html
# https://nixos.wiki/wiki/Cheatsheet
# https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager
# https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
# https://github.com/mitchellh/nixos-config/blob/c812e681dd72dd0d818fbdce275e75171ea858b2/users/mitchellh/home-manager.nix

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "viktor";
  home.homeDirectory = "/home/viktor";

  # Pkgs to install
  # Find through: nix-env -qaP <pkg>
  # Or: https://search.nixos.org/packages
  home.packages = [
    pkgs.fish
    pkgs.tmux
    pkgs.git
    pkgs.emacs28NativeComp

    pkgs.go_1_18
    pkgs.gopls

    pkgs.fd
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.rofi
    pkgs.tree
    pkgs.watch
  ];

  home.file.".config/fish/config.fish".source = ./fish/config.fish;
  home.file.".config/fish/conf.d/nix.fish".source = ./fish/conf.d/nix.fish;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  home.file.".gitconfig".source = ./git/gitconfig;

  programs.ssh.enable = true; # TODO: Does this actually work?

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
