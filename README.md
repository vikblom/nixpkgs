# Nixpkgs

```
nix run home-manager/release-24.05 -- init --switch ~/nixpkgs
home-manager switch --flake ~/nixpkgs
```

Go setup to squeeze in before nix:
```
> cat .zshrc
export PATH=/Users/viktor/go/bin:$PATH
```

Iterm2 set Custom Shell to `which fish` and pass `tmux` as text at start.
