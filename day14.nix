stdin:
let
  lib = (import <nixpkgs> { }).lib;

  input = builtins.map
    (
      l:
      let
        a = builtins.map lib.strings.toInt (
          builtins.match
            "p=([0-9]+),([0-9]+) v=(-?[0-9]+),(-?[0-9]+)"
            l
        );
      in
      {
        pos = { x = builtins.elemAt a 0; y = builtins.elemAt a 1; };
        vel = { x = builtins.elemAt a 2; y = builtins.elemAt a 3; };
      }
    )
    (
      lib.strings.splitString "\n" stdin
    );

  mod = a: b: lib.trivial.mod ((lib.trivial.mod a b) + b) b;

  part1 = input:
    lib.attrsets.foldlAttrs (a: _: builtins.mul a) 1 (
      lib.attrsets.filterAttrs (k: _: k != "0") (
        lib.attrsets.mapAttrs (_: builtins.length) (
          builtins.groupBy
            ({ x, y }: toString (
              if (x > 50 && y > 51) then 1 else
              if (x < 50 && y < 51) then 2 else
              if (x > 50 && y < 51) then 3 else
              if (x < 50 && y > 51) then 4 else 0
            ))
            (builtins.map
              ({ pos, vel }: {
                x = mod (pos.x + vel.x * 100) 101;
                y = mod (pos.y + vel.y * 100) 103;
              })
              input
            )
        )
      )
    );
  part2 = input: 0;
in
''
  Part 1: ${toString (part1 input)}
  Part 2: ${toString (part2 input)}
''

