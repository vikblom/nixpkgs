{ pkgs, lib, ... }:

# Nix config.
# Most parts inspired/stolen from github.com/mitchellh/nixos-config.
#
#
# https://nix-community.github.io/home-manager/index.html
# https://nixos.wiki/wiki/Cheatsheet
# https://www.bekk.christmas/post/2021/16/dotfiles-with-nix-and-home-manager
# https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
# https://github.com/mitchellh/nixos-config/blob/c812e681dd72dd0d818fbdce275e75171ea858b2/users/mitchellh/home-manager.nix
#
# https://github.com/NixOS/nixpkgs/issues/196651
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Colorful MANPAGER
  # manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
  #   sh -c 'col -bx | bat -l man -p'
  # '' else ''
  #   col -bx | bat --language man --style plain
  # ''));
in
{
  # For terraform.
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";


  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "viktor";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/viktor" else "/home/viktor";

  xdg.enable = true;

  # Workaround for
  # https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false;

  # -- Packages

  # environment.systemPackages = [
  #   ghostty.packages.x86_64-linux.default
  # ];

  # Pkgs to install
  # Find through: nix-env -qaP <pkg>
  # Or: https://search.nixos.org/packages
  home.packages = [
    # ghostty.packages.aarch64-darwin.default
    # pkgs.fish
    pkgs.tmux
    pkgs.git
    pkgs.openssh
    pkgs.direnv
    # pkgs.emacs28NativeComp
    pkgs.neovim
    pkgs.tree-sitter

    # fonts
    pkgs.roboto
    pkgs.inconsolata

    # Skip so that we can use local variants.
    # pkgs.go
    # pkgs.gopls
    # pkgs.delve
    # For profiling
    pkgs.graphviz

    # pkgs.rustc
    # pkgs.cargo
    # pkgs.rustup # So we can rustup --docs
    # pkgs.rust-analyzer
    # pkgs.gdb
    # pkgs.linuxPackages_latest.perf

    pkgs.nixfmt-classic
    pkgs.nil
    pkgs.nix-search-cli

    pkgs.cmake

    pkgs.coreutils
    pkgs.inetutils
    pkgs.bat
    pkgs.fd
    pkgs.htop
    pkgs.jq
    pkgs.ripgrep
    pkgs.tree
    pkgs.watch
    pkgs.fzf
    pkgs.iperf
    pkgs.pprof

    pkgs.kubectl
    pkgs.istioctl
    pkgs.kubernetes-helm
    pkgs.argocd

    # Daemon installed separately
    pkgs.docker
    pkgs.docker-compose
    pkgs.dive

    pkgs.postgresql_15_jit
    pkgs.sqlite
    pkgs.dbmate

    # Klash
    pkgs.awscli2
    pkgs.azure-cli
    pkgs.openvpn
    pkgs.lftp
    # pkgs.yarn
    # pkgs.corepack
    # pkgs.nodejs_20
    pkgs.ffmpeg
    # pkgs.pyenv
    # pkgs.pipx
    pkgs.nodePackages.dotenv-cli
    pkgs.nodePackages.prisma
    pkgs.terraform
    pkgs.redis
    pkgs.glab # gitlab cli
    # brew'd
    # tunnelto
    pkgs.livekit
    pkgs.livekit-cli
    pkgs.nodePackages.prettier
    pkgs.duckdb

  ] ++ (lib.optionals isDarwin [
    pkgs.iterm2
    #pkgs.lima
    #pkgs.colima
    # pkgs.podman
    pkgs.utm

    # pkgs.yabai
    # pkgs.skhd

  ]) ++ (lib.optionals isLinux [
    pkgs.alacritty
    pkgs.kitty
    # pkgs.chromium
    pkgs.firefox
    pkgs.rofi

    pkgs.evince
  ]);

  # --  Env

  home.sessionVariables = {
    EDITOR = "emacsclient -nw -a emacs";
    # EDITOR = "nvim";
    LESS = "-r";
    # PAGER = "less -x4 -FirSwX";
    PAGER = "bat -p";
    # MANPAGER = "${manpager}/bin/manpager";

    COMPOSE_MENU = "0";

    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  # -- Dotfiles

  home.file.".gitconfig".source = ./git/gitconfig;
  home.file.".tmux.conf".source = ./tmux/tmux.conf;
  xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."i3status/config".text = builtins.readFile ./i3status;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ./alacritty.yml;

  # -- Programs

  # Patch up the nix env vars on MacOS.
  # https://github.com/lilyball/nix-env.fish
  home.file.".config/fish/conf.d/nix.fish".source = (if isDarwin then ./fish/conf.d/nix.fish else null);
  home.file.".config/fish/conf.d/nix-env.fish".source = (if isDarwin then ./fish/conf.d/nix-env.fish else null);
  # AWS autocomplete
  home.file.".config/fish/conf.d/aws.fish".source = ./fish/conf.d/aws.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      (builtins.readFile ./fish/config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    shellAliases = {
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gdiff = "git diff";
      gp = "git push";
      gri = "git rebase --interactive";
      gs = "git status";
      gt = "git tag";
    };
  };

  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
  #   }))
  #   (a: b: { }) # Must return a set.
  # ];
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29;
  };

  # -- Graphics
  gtk = {
    enable = isLinux;

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
