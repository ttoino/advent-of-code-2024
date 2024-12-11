fun getInput(): List<Long> = readln().split(' ').map(String::toLong)

fun <T> repeat(n: Int, inp: T, f: (T) -> T): T {
    var res = inp
    repeat(n) {
        println(it)
         res = f(res) }
    return res
}

fun blink(stones: List<Long>): List<Long> = stones.flatMap { 
    if (it == 0L) listOf(1L) 
    else if (it.toString().length.rem(2) == 0) it.toString().chunked(it.toString().length/2).map(String::toLong)
    else listOf(it * 2024L)
}

fun part1(input: List<Long>) = repeat(25, input, ::blink).size

fun part2(input: List<Long>) = repeat(75, input, ::blink).size

val inp = getInput()
println(inp)
println("Part 1: ${part1(inp)}")
println("Part 2: ${part2(inp)}")
