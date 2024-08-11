{
  description = "Home Manager configuration of viktor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."viktor" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          # Disable news.
          {
            config = {
              news.display = "silent";
              news.json = nixpkgs.lib.mkForce { };
              news.entries = nixpkgs.lib.mkForce [ ];
            };
          }
        ];
      };
    };
}
