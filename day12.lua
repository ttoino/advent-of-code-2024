local function get_input()
    local i = io.read("*all")
    local result = {}

    for line in i:gmatch("[^\n]+") do
        local row = {}
        for c in line:gmatch(".") do
            table.insert(row, c)
        end
        table.insert(result, row)
    end

    return result
end

local function solve(input, part2)
    local visited = {}
    local queue = {{1, 1}}
    local result = 0

    while #queue > 0 do
        local current = table.remove(queue, 1)
        local c = current[1] .. "," .. current[2]
        
        if visited[c] then goto continue end

        local region = input[current[1]][current[2]]
        local region_queue = {current}
        local visited_sides = {}
        local area = 0
        local perimeter = 0

        while #region_queue > 0 do
            local key = table.remove(region_queue, 1)
            local k = key[1] .. "," .. key[2]
            if visited[k] then goto continue end
            visited[k] = true

            area = area + 1

            for _, dir in ipairs({{0, 1}, {0, -1}, {1, 0}, {-1, 0}}) do
                local x, y = key[1] + dir[1], key[2] + dir[2]
                
                local other = (input[x] or {})[y]

                if other == region then
                    table.insert(region_queue, {x, y})
                else
                    local side = x .. "," .. y .. ':' .. dir[1] .. ',' .. dir[2]
                    visited_sides[side] = true

                    local s1x, s1y = x + dir[2], y + dir[1]
                    local s2x, s2y = x - dir[2], y - dir[1]
                    local s1 = s1x .. "," .. s1y .. ':' .. dir[1] .. ',' .. dir[2]
                    local s2 = s2x .. "," .. s2y .. ':' .. dir[1] .. ',' .. dir[2]

                    if not part2 or (not visited_sides[s1] and not visited_sides[s2]) then
                        perimeter = perimeter + 1
                    elseif visited_sides[s1] and visited_sides[s2] then
                        perimeter = perimeter - 1
                    end

                    if other ~= nil then
                        table.insert(queue, {x, y})
                    end
                end
            end

            ::continue::
        end

        -- print(region, area, perimeter)
        result = result + area * perimeter

        ::continue::
    end

    return result
end

function part1(input)
    return solve(input, false)
end

function part2(input)
    return solve(input, true)
end

local input = get_input()
print("Part 1:", part1(input))
print("Part 2:", part2(input))
