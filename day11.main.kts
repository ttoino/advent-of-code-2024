@file:DependsOn("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")

import java.math.BigInteger
import java.util.SortedMap
import kotlin.coroutines.*
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.*

fun getInput(): List<BigInteger> = readln().split(' ').map(String::toBigInteger)

// Thank you https://medium.com/@josehhbraz/parallel-map-in-flow-kotlin-f9735c9dc237
fun <T, R> Flow<T>.parallelMap(
    context: CoroutineContext = EmptyCoroutineContext,
    transform: suspend (T) -> R
): Flow<R> {
    val scope = CoroutineScope(context + SupervisorJob())
    return map {
        scope.async { transform(it) }
    }
    .buffer()
    .map { it.await() }
    .flowOn(context)
}

suspend fun blink(n: Int, stones: Flow<BigInteger>): Long = stones.parallelMap { blinkEl(n, it)}.reduce(Long::plus)

val cache = mutableMapOf<Pair<Int, BigInteger>, Long>()
val bi2024 = 2024.toBigInteger()

suspend fun blinkEl(n: Int, stone: BigInteger): Long {
    if (n == 0) return 1

    cache[n to stone]?.let { return it }

    val s = stone.toString()
    val result = if (stone == BigInteger.ZERO) blinkEl(n-1, BigInteger.ONE)
        else if (s.length.rem(2) == 0)
            blink(n-1, s.chunked(s.length.div(2)).map(String::toBigInteger).asFlow())
        else blinkEl(n-1, stone * bi2024)

    cache[n to stone] = result
    return result
}

fun part1(input: List<BigInteger>) = runBlocking(Dispatchers.IO) { blink(25, input.asFlow()) }

fun part2(input: List<BigInteger>) = runBlocking(Dispatchers.IO) { blink(75, input.asFlow()) }

val inp = getInput()
println("Part 1: ${part1(inp)}")
println("Part 2: ${part2(inp)}")
