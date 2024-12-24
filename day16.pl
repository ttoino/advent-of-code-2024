:- use_module(library(clpfd)).

get_input(Input) :-
    read_line_to_codes(user_input, Line),
    (
        Line = end_of_file, Input = [];
        get_input(Others), Input = [Line | Others]
    ).

setup_el(_, _, [], [], []).
setup_el(
    West,
    [North | NextPrevSouths],
    [Code | NextCodes],
    [Code-North-West-South-East | NextGraphs],
    [South | NextSouths]
) :-
    [North, West, South, East] ins 0..1,
    setup_el(East, NextPrevSouths, NextCodes, NextGraphs, NextSouths).

setup_line(_, [], []).
setup_line(PrevSouths, [Line | NextLines], [GraphLine | NextGraphs]) :-
    setup_el(_, PrevSouths, Line, GraphLine, Souths),
    setup_line(Souths, NextLines, NextGraphs).

setup_graph([I | Input], Graph) :-
    same_length(I, Souths),
    setup_line(Souths, [I | Input], Graph).

setup_el_constraints([], []).
setup_el_constraints([0'#-North-West-South-East | Graph], [0 | Scores]) :- !,
    sum([North, West, South, East], #=, 0),
    setup_el_constraints(Graph, Scores).
setup_el_constraints([0'S-North-West-South-East | Graph], [Score | Scores]) :- !,
    sum([North, West, South, East], #=, 1),
    East #= 1 #<==> Score #= 0,
    East #= 0 #<==> Score #= 1000,
    setup_el_constraints(Graph, Scores).
setup_el_constraints([0'E-North-West-South-East | Graph], [1 | Scores]) :- !,
    sum([North, West, South, East], #=, 1),
    setup_el_constraints(Graph, Scores).
setup_el_constraints([0'.-North-West-South-East | Graph], [Score | Scores]) :- !,
    sum([North, West, South, East], #=, Sum),
    Sum #= 0 #\/ Sum #= 2,
    Sum #= 0 #==> Score #= 0,
    North + South #= 2 #\/ West + East #= 2 #<==> Parallel,
    Sum #= 2 #/\ Parallel #==> Score #= 1,
    Sum #= 2 #/\ #\ Parallel #==> Score #= 1001,
    setup_el_constraints(Graph, Scores).
setup_el_constraints([Code-_-_-_-_ | Graph], [0 | Scores]) :- !,
    char_code(Atom, Code),
    write('Invalid character: '), write(Atom), write('('), write(Code), write(')'), nl,
    setup_el_constraints(Graph, Scores).
    
setup_line_constraints([], []).
setup_line_constraints([Line | Graph], [ScoreLine | Scores]) :-
    setup_el_constraints(Line, ScoreLine),
    setup_line_constraints(Graph, Scores).

line_variables([], []).
line_variables([_-North-West-South-East | Line], [North, West, South, East | LineVars]) :-
    line_variables(Line, LineVars).
variables([], []).
variables([Line | Graph], [LineVars | GraphVars]) :-
    line_variables(Line, LineVars),
    variables(Graph, GraphVars).

print_down([]) :- nl.
print_down([_-_-_-South-_ | Line]) :-
    (
        \+ ground(South), !, write('?');
        South = 1, !, write('|');
        South = 0, !, write(' ')
    ),
    write(' '),
    print_down(Line).
print_line([]) :- nl.
print_line([Code-_-_-_-East]) :-
    char_code(Atom, Code), write(Atom), nl.
print_line([Code-_-_-_-East | Line]) :-
    char_code(Atom, Code), write(Atom),
    (
        \+ ground(East), !, write('?');
        East = 1, !, write('-');
        East = 0, !, write(' ')
    ),
    print_line(Line).
print_graph([]).
print_graph([Line]) :- print_line(Line).
print_graph([Line | Graph]) :-
    print_line(Line),
    print_down(Line),
    print_graph(Graph).

part1(Input, Output) :-
    setup_graph(Input, Graph),
    print_graph(Graph),
    setup_line_constraints(Graph, Scores),
    print_graph(Graph),
    append(Scores, ScoresFlat),
    sum(ScoresFlat, #=, Output),
    variables(Graph, Vars),
    append(Vars, VarsFlat),
    !,
    write('Labeling'), nl,
    labeling([min(Output), ff], VarsFlat),
    print_graph(Graph).

part2(_Input, Output) :-
    Output is 0.

main :-
    get_input(Input),
    % Input = [
    %     `###############`,
    %     `#.......#....E#`,
    %     `#.#.###.#.###.#`,
    %     `#.....#.#...#.#`,
    %     `#.###.#####.#.#`,
    %     `#.#.#.......#.#`,
    %     `#.#.#####.###.#`,
    %     `#...........#.#`,
    %     `###.#.#####.#.#`,
    %     `#...#.....#.#.#`,
    %     `#.#.#.###.#.#.#`,
    %     `#.....#...#.#.#`,
    %     `#.###.#.#.#.#.#`,
    %     `#S..#.....#...#`,
    %     `###############`
    % ],
    % Input = [
    %     `#################`,
    %     `#...#...#...#..E#`,
    %     `#.#.#.#.#.#.#.#.#`,
    %     `#.#.#.#...#...#.#`,
    %     `#.#.#.#.###.#.#.#`,
    %     `#...#.#.#.....#.#`,
    %     `#.#.#.#.#.#####.#`,
    %     `#.#...#.#.#.....#`,
    %     `#.#.#####.#.###.#`,
    %     `#.#.#.......#...#`,
    %     `#.#.###.#####.###`,
    %     `#.#.#...#.....#.#`,
    %     `#.#.#.#####.###.#`,
    %     `#.#.#.........#.#`,
    %     `#.#.#.#########.#`,
    %     `#S#.............#`,
    %     `#################`
    % ],
    part1(Input, Part1),
    write('Part 1: '), write(Part1), nl,
    part2(Input, Part2),
    write('Part 2: '), write(Part2), nl.
