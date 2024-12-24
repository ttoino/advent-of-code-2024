:- use_module(library(heaps)).
:- use_module(library(ordsets)).

get_input(Input) :-
    read_line_to_codes(user_input, Line),
    (
        Line = end_of_file, Input = [];
        get_input(Others), Input = [Line | Others]
    ).

nnth0(Row-Col, Graph, El) :-
    nth0(Row, Graph, RowStr),
    nth0(Col, RowStr, El).

add_dirs(_, Heap, _, _, [], Heap).
add_dirs(Graph, Heap, Distance, Row-Col-Dir, [RowD-ColD-DirD | Dirs], FinalHeap) :-
    (
        Dir = DirD -> NewDistance is Distance + 1;
        NewDistance is Distance + 1001
    ),
    NewRow is Row + RowD,
    NewCol is Col + ColD,
    (
        nnth0(NewRow-NewCol, Graph, 0'#) -> NewHeap = Heap;
        add_to_heap(Heap, NewDistance, NewRow-NewCol-DirD, NewHeap)
    ),
    add_dirs(Graph, NewHeap, Distance, Row-Col-Dir, Dirs, FinalHeap).

dijkstra(Heap, Visited, Graph, Distance) :-
    % heap_size(Heap, Size),
    % write(Size), nl,
    get_from_heap(Heap, CurrentDistance, Row-Col-Dir, NewHeap),
    (
        ord_memberchk(Row-Col, Visited) -> dijkstra(NewHeap, Visited, Graph, Distance);

        ord_add_element(Visited, Row-Col, NewVisited),
        nth0(Row, Graph, R),
        nth0(Col, R, El),
        (
            El = 0'E -> Distance = CurrentDistance;

            add_dirs(Graph, NewHeap, CurrentDistance, Row-Col-Dir, [0-1-east, 0-(-1)-west, 1-0-south, (-1)-0-north], FinalHeap),
            dijkstra(FinalHeap, NewVisited, Graph, Distance)
        )
    ).

part1(Input, Output) :-
    nnth0(SR-SC, Input, 0'S),
    singleton_heap(Heap, 0, SR-SC-east),
    ord_empty(Visited),
    dijkstra(Heap, Visited, Input, Output).

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
