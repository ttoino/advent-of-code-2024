{
  description = "Advent of Code 2024 Solutions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      packages.${system} = {
        day1 = pkgs.writeShellApplication {
          name = "day1";
          runtimeInputs = [ (pkgs.dyalog.override { acceptLicense = true; }) ];
          text = "dyalog -script ${./day1.apl}";
        };
      };
    };
}
