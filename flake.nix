{
  description = "aoc-dev";
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        overlays = [
          haskellNix.overlay
          (final: prev: {
            aoc-dev = final.haskell-nix.project' {
              name = "aoc-dev";
              src = ./.;
              compiler-nix-name = "ghc902";
              shell.tools = {
                cabal = { };
                # hlint = {};
                haskell-language-server = { };
              };
            };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
        flake = pkgs.aoc-dev.flake { };
      in
      flake // { packages.default = flake.packages."aoc-dev:exe:aoc-dev"; }
    );
}
