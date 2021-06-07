{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      pkg = { stdenv, lib, rustPlatform, fetchFromGitHub }:
        rustPlatform.buildRustPackage {
          pname = "nix-eval-lsp";
          version = "0.1.0";
          src = ./.;
          cargoSha256 = "sha256-OoHGx9RLWahJ11z9EmnnJDj/b2GJhQgJslTmSVuxc7Y=";
          RUSTC_BOOTSTRAP = 1;
        };
    in flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.nix-eval-lsp = pkgs.callPackage pkg { };
        defaultPackage = self.packages.${system}.nix-eval-lsp;
      }) // {
        overlay = final: prev: { nix-eval-lsp = prev.callPackage pkg { }; };
      };
}
