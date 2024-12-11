fun getInput(): List<Long> = readln().split(' ').map(String::toLong)

fun blink(n: Int, stones: List<Long>): Long = stones.sumOf { blinkEl(n, it) }

val cache = mutableMapOf<Pair<Int, Long>, Long>()

fun blinkEl(n: Int, stone: Long): Long {
    if (n == 0) return 1

    cache[n to stone]?.let { return it }

    val s = stone.toString()
    val result = if (stone == 0L) blinkEl(n-1, 1L)
        else if (s.length.rem(2) == 0) blink(n-1, s.chunked(s.length.div(2)).map(String::toLong))
        else blinkEl(n-1, stone * 2024L)

    cache[n to stone] = result
    return result
}

fun part1(input: List<Long>) = blink(25, input)

fun part2(input: List<Long>) = blink(75, input)

val inp = getInput()
println("Part 1: ${part1(inp)}")
println("Part 2: ${part2(inp)}")
