{
  description = "Flake for nix-search-by-maintainer";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    sbomnix.url = "github:tiiuae/sbomnix";
  };
  outputs = inputs @ {
    flake-parts,
    systems,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import systems;
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages = {
          default = pkgs.writeShellApplication {
            name = "nix-search-by-maintainer";
            runtimeInputs = [inputs'.sbomnix.packages.sbomnix pkgs.csvkit pkgs.gum];
            text = builtins.readFile ./script.sh;
          };
        };
      };
    };
}
