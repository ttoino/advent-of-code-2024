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
        day1 = pkgs.writeShellApplication {
          name = "day1";
          runtimeInputs = [ (pkgs.dyalog.override { acceptLicense = true; }) getInput ];
          text = "getInput 1 | dyalog -script ${./day1.apl} 2> /dev/null";
        };
        day2 = pkgs.writeShellApplication {
          name = "day2";
          runtimeInputs = [ pkgs.bash getInput ];
          text = "getInput 2 | bash ${./day2.bash}";
        };
        day3 = pkgs.writeShellApplication {
          name = "day3";
          runtimeInputs = [ getInput (pkgs.writeCBin "day3Bin" (builtins.readFile ./day3.c)) ];
          text = "getInput 3 | day3Bin";
        };
        day4 = pkgs.writeShellApplication {
          name = "day4";
          runtimeInputs = [ pkgs.dart getInput ];
          text = "getInput 4 | dart run ${./day4.dart}";
        };
      };
    };
}
