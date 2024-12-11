defmodule AOC do
    def read_input() do
        IO.stream(:stdio, :line)
            |> Enum.map(&String.trim/1)
            |> Enum.map(&String.split(&1, ["|", ","], trim: true))
            |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
            |> Enum.chunk_while([], fn
                [], acc -> {:cont, acc, []}
                line, acc -> {:cont, acc ++ [line]}
            end, &{:cont, &1, []})
            |> List.to_tuple()
    end

    def ordered?(x, rules) do
        Enum.all?(rules, fn [a, b] ->
            ai = Enum.find_index(x, &(&1 == a))
            bi = Enum.find_index(x, &(&1 == b))
            ai == nil or bi == nil or ai < bi
        end)
    end

    def part1({rules, pages}) do
        pages
            |> Stream.filter(&ordered?(&1, rules))
            |> Stream.map(&Enum.at(&1, div(length(&1), 2)))
            |> Enum.sum()
    end

    def order(x, rules) do
        if AOC.ordered?(x, rules) do
            x
        else
            rules
                |> Enum.reduce(x, fn [a, b], acc ->
                    ai = Enum.find_index(acc, &(&1 == a))
                    bi = Enum.find_index(acc, &(&1 == b))
                    if ai == nil or bi == nil or ai < bi do
                        acc
                    else
                        acc
                            |> List.insert_at(bi, a)
                            |> List.delete_at(ai + 1)
                    end
                end)
                |> order(rules)
        end
    end

    def part2({rules, pages}) do
        pages
            |> Stream.filter(&!ordered?(&1, rules))
            |> Stream.map(&order(&1, rules))
            |> Stream.map(&Enum.at(&1, div(length(&1), 2)))
            |> Enum.sum()
    end
end

input = AOC.read_input()
IO.puts("Part 1: #{AOC.part1(input)}")
IO.puts("Part 2: #{AOC.part2(input)}")
