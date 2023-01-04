{ config, pkgs, lib, ... }:

# https://nix-community.github.io/home-manager/index.html
# https://nixos.wiki/wiki/Cheatsheet
# https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager
# https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
# https://github.com/mitchellh/nixos-config/blob/c812e681dd72dd0d818fbdce275e75171ea858b2/users/mitchellh/home-manager.nix
#
# https://github.com/NixOS/nixpkgs/issues/196651
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "viktor";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/viktor" else "/home/viktor";

  # Pkgs to install
  # Find through: nix-env -qaP <pkg>
  # Or: https://search.nixos.org/packages
  home.packages = [
    pkgs.alacritty
    pkgs.kitty
    # FIXME: pkgs.iterm2
    pkgs.fish
    pkgs.tmux
    pkgs.git
    pkgs.direnv
    pkgs.emacs28NativeComp
    pkgs.evince

    pkgs.go
    pkgs.gopls
    pkgs.delve

    # pkgs.rustc
    # pkgs.cargo
    pkgs.rustup # So we can rustup --docs
    pkgs.rust-analyzer
    pkgs.gdb
    pkgs.linuxPackages_latest.perf

    pkgs.fd
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch

    pkgs.kubectl

    # Daemon installed separately
    pkgs.docker
    pkgs.docker-compose

    pkgs.postgresql
    pkgs.sqlite
    pkgs.dbmate
  ];

  home.file.".config/fish/config.fish".source = ./fish/config.fish;
  home.file.".config/fish/conf.d/nix.fish".source = ./fish/conf.d/nix.fish;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  # Collides with tools at work.
  # home.file.".gitconfig".source = ./git/gitconfig;

  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor";
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.sessionVariables.GTK_THEME = "palenight";

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
