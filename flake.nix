{
  description = "Home Manager configuration of viktor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
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
