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
          runtimeInputs = [ getInput (
            pkgs.runCommand "day06Bin" {
                nativeBuildInputs = [ pkgs.gfortran ];
            } ''
              n="$out/bin/day06Bin"
              mkdir -p $(dirname $n)
              gfortran -fimplicit-none -fcheck=all -ffree-line-length-512 ${./day06.f90} -o "$n"
            ''
          ) ];
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
      };
    };
}
