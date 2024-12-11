const Map = Array{Int, 2}

getInput()::Map = reduce(hcat, collect.(readlines())).-'0'

function visit(base::T, final::Function, merge::Function, map::Map, i::CartesianIndex)::T where T
    v = map[i]
    x, y = Tuple(i)

    if v == 9 return final(i) end

    s = base

    for (nx, ny) in [(x, y-1), (x, y+1), (x-1, y), (x+1, y)]
        if nx < 1 || ny < 1 || nx > size(map, 1) || ny > size(map, 2) || map[nx, ny] != v + 1
            continue
        end

        s = merge(s, visit(base, final, merge, map, CartesianIndex(nx, ny)))
    end

    return s
end

solve(f::Function, input::Map) :: Int = (
        filter(i -> input[i] == 0, CartesianIndices(input)) 
        .|> Base.Fix1(f, input)
    ) |> sum

score(map::Map, i::CartesianIndex) :: Set{CartesianIndex} = visit(Set(), i -> Set([i]), union, map, i)
part1 = Base.Fix1(solve, length ∘ score)

rating(map::Map, i::CartesianIndex) :: Int = visit(0, _ -> 1, +, map, i)
part2 = Base.Fix1(solve, rating)

input = getInput()
println("Part 1: ", part1(input))
println("Part 2: ", part2(input))
