{
  description = "Advent of Code 2024 Solutions";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

      getInput = pkgs.writeShellApplication {
        name = "getInput";
        runtimeInputs = [ pkgs.curl ];
        text = ''
          CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/aoc2024"
          mkdir -p "$CACHE_DIR"
          SESSION_FILE="$CACHE_DIR/session"
          OUTPUT_FILE="$CACHE_DIR/day$1"

          while [ ! -f "$OUTPUT_FILE" ]; do
            if [ ! -f "$SESSION_FILE" ]; then
              echo -n "Please enter your session cookie: " >&2
              read -r SESSION
              echo "$SESSION" > "$SESSION_FILE"
            fi

            if ! curl "https://adventofcode.com/2024/day/$1/input" -sf -H "Cookie: session=$(cat "$SESSION_FILE")" -o "$OUTPUT_FILE"; then
              echo "Invalid session cookie" >&2
              rm -f "$SESSION_FILE" "$OUTPUT_FILE"
            fi
          done

          cat "$OUTPUT_FILE"
        '';
      };
    in
    {
      packages.${system} = {
        day01 = pkgs.writeShellApplication {
          name = "day01";
          runtimeInputs = [ getInput (pkgs.dyalog.override { acceptLicense = true; }) ];
          text = "getInput 1 | dyalog -script ${./day01.apl} 2> /dev/null";
        };
        day02 = pkgs.writeShellApplication {
          name = "day02";
          runtimeInputs = [ getInput pkgs.bash ];
          text = "getInput 2 | bash ${./day02.bash}";
        };
        day03 = pkgs.writeShellApplication {
          name = "day03";
          runtimeInputs = [ getInput (pkgs.writeCBin "day03Bin" (builtins.readFile ./day03.c)) ];
          text = "getInput 3 | day03Bin";
        };
        day04 = pkgs.writeShellApplication {
          name = "day04";
          runtimeInputs = [ getInput pkgs.dart ];
          text = "getInput 4 | dart run ${./day04.dart}";
        };
        day05 = pkgs.writeShellApplication {
          name = "day05";
          runtimeInputs = [ getInput pkgs.elixir ];
          text = "getInput 5 | elixir ${./day05.exs}";
        };
        day06 = pkgs.writeShellApplication {
          name = "day06";
          runtimeInputs = [
            (
              pkgs.runCommand "day06Bin"
                {
                  nativeBuildInputs = [ pkgs.gfortran ];
                } ''
                n="$out/bin/day06Bin"
                mkdir -p $(dirname $n)
                gfortran -fimplicit-none -fcheck=all -ffree-line-length-512 ${./day06.f90} -o "$n"
              ''
            )
            getInput
          ];
          text = "getInput 6 | day06Bin";
        };
        day07 = pkgs.writeShellApplication {
          name = "day07";
          runtimeInputs = [ getInput pkgs.go ];
          text = "getInput 7 | go run ${./day07.go}";
        };
        day08 = pkgs.writeShellApplication {
          name = "day08";
          runtimeInputs = [ pkgs.ghc getInput ];
          text = "getInput 8 | runghc ${./day08.hs}";
        };
        day09 = pkgs.writeShellApplication {
          name = "day09";
          runtimeInputs = [ pkgs.idris2 getInput ];
          text = "getInput 9 | idris2 -x elba --source-dir / ${./day09.idr}";
        };
        day10 = pkgs.writeShellApplication {
          name = "day10";
          runtimeInputs = [ pkgs.julia getInput ];
          text = "getInput 10 | julia ${./day10.jl}";
        };
        day11 = pkgs.writeShellApplication {
          name = "day11";
          runtimeInputs = [ pkgs.kotlin getInput ];
          text = "getInput 11 | kotlinc -script ${./day11.kts}";
        };
        day12 = pkgs.writeShellApplication {
          name = "day12";
          runtimeInputs = [ pkgs.lua getInput ];
          text = "getInput 12 | lua ${./day12.lua}";
        };
        day13 = pkgs.writeShellApplication {
          name = "day13";
          runtimeInputs = [ pkgs.maxima getInput ];
          text = "getInput 13 | maxima --very-quiet --init-mac=${./day13.mac} --batch-string='main()$'";
        };
        day14 = pkgs.writeShellApplication {
          name = "day14";
          runtimeInputs = [ getInput ];
          text = "nix eval --show-trace --raw --file ${./day14.nix} --apply \"f: f ''$(getInput 14)''\"";
        };
        day15 = pkgs.writeShellApplication {
          name = "day15";
          runtimeInputs = [ pkgs.ocaml getInput ];
          text = "getInput 15 | ocaml ${./day15.ml}";
        };
        day16 = pkgs.writeShellApplication {
          name = "day16";
          runtimeInputs = [ pkgs.swi-prolog getInput ];
          text = "getInput 16 | swipl -g main ${./day16.pl}";
        };
        day17 = pkgs.writeShellApplication {
          name = "day17";
          runtimeInputs = [
            (
              pkgs.runCommandCC "day17Bin"
                {
                  nativeBuildInputs = [ pkgs.rustc ];
                } ''
                n="$out/bin/day17Bin"
                mkdir -p $(dirname $n)
                rustc ${./day17.rs} -o "$n"
              ''
            )
            getInput
          ];
          text = "getInput 17 | day17Bin";
        };
        day18 = pkgs.writeShellApplication {
          name = "day18";
          runtimeInputs = [
            pkgs.scala-cli
            getInput
          ];
          text = ''
            getInput 18 | scala-cli run ${./day18.scala}
          '';
        };
        day19 = pkgs.writeShellApplication {
          name = "day19";
          runtimeInputs = [ pkgs.deno getInput ];
          text = "getInput 19 | deno run ${./day19.ts}";
        };
      };
    };
}
