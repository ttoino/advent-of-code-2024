type box_map = char array array;;
type instructions = (int * int) list;;
type input = box_map * instructions;;

let rec get_lines () : string list = 
    try let line = read_line () in line :: get_lines ()
    with End_of_file -> [];;

let bimap (f : 'a -> 'c) (g : 'b -> 'd) ((x, y) : 'a * 'b) : 'c * 'd = (f x, g y);;

let combine (f : 'a -> 'b -> 'c) ((a, b) : 'a * 'a) ((x, y): 'b * 'b) : 'c * 'c =
    (f a x, f b y);;
let ( #+ ) = combine (+);;

let cons_unique (a : 'a) (l : 'a list) : 'a list =
    if List.exists ((=)a) l then l else (a :: l);;
let ( #:: ) = cons_unique;;

let compose (f : 'b -> 'c) (g : 'a -> 'b) : 'a -> 'c = fun a -> g a |> f;;
let ( <| ) = compose;;

let dir (c : char) : int * int = match c with
    | '^' -> (0, -1)    
    | '<' -> (-1, 0)
    | 'v' -> (0, 1)
    | '>' -> (1, 0)
    | _ -> (0, 0);;

let input : input =  get_lines ()
    |> List.partition (String.exists (fun c -> c == '#' || c == '.'))
    |> bimap (
        Array.of_list <| List.map (Array.of_seq <| String.to_seq)
    ) (
        List.map dir <| List.of_seq <| String.to_seq <| List.fold_left (^) ""
    );;

let find_robot (map : box_map) : int * int =
    let rec loop y = match Array.find_index ((=)'@') map.(y) with
        | None -> loop (y + 1)
        | Some x -> (x, y)
    in loop 0;;

let gps (map : box_map) : int =
    Array.mapi (fun y -> Array.mapi (fun x e -> 
        if e == 'O' || e == '[' then y * 100 + x else 0
    )) map 
    |> Array.fold_left (Array.fold_left (+)) 0;;

let swap ((x1, y1): int * int) ((x2, y2) : int * int) (map : box_map) : unit =
    let a = map.(y2).(x2)
    in map.(y2).(x2) <- map.(y1).(x1);
    map.(y1).(x1) <- a;;

let push (dir: int * int) (map : box_map) : unit =
    let rec find ps l =
        if ps = [] then l
        else if List.exists (fun (x,y) -> map.(y).(x) = '#') ps then []
        else find (List.fold_left (fun ps p -> match map.(snd p).(fst p) with
            | '[' when (snd dir) <> 0 -> (p #+ (1,0) #+ dir) #:: ((p #+ dir) #:: ps)
            | ']' when (snd dir) <> 0 -> (p #+ (-1,0) #+ dir) #:: ((p #+ dir) #:: ps)
            | 'O' | '[' | ']' | '@' -> (p #+ dir) #:: ps
            | _ -> ps
        ) [] ps) (List.fold_left (fun l p -> match map.(snd p).(fst p) with
            | '[' when (snd dir) <> 0 -> (p #+ (1,0)) #:: (p #:: l)
            | ']' when (snd dir) <> 0 -> (p #+ (-1,0)) #:: (p #:: l)
            | 'O' | '[' | ']' | '@' -> p #:: l
            | _ -> l
        ) l ps)
    in List.iter (fun p -> swap p (p #+ dir) map) (find [find_robot map] []);;

let solve ((map, instructions) : input) : int =
    let rec iteration (i : instructions) : unit =
        match i with
        | [] -> ()
        | h :: t -> push h map; iteration t
    in iteration instructions; gps map;;

let part1 ((map, instructions): input) : int =
    solve (Array.init (Array.length map) (fun y -> Array.copy map.(y)), instructions);;

let wide (map: box_map) : box_map = Array.init (Array.length map) (fun y -> 
        Array.fold_left (fun a e -> Array.append a (match e with
            | '#' -> [|'#';'#'|]
            | '.' -> [|'.';'.'|]
            | '@' -> [|'@';'.'|]
            | 'O' -> [|'[';']'|]
            | _ -> [||]
        )) [||] map.(y)
    );;

let part2 ((map, instructions) : input) : int = solve (wide map, instructions);;

print_endline ("Part 1: " ^ string_of_int (part1 input));;
print_endline ("Part 2: " ^ string_of_int (part2 input));;
