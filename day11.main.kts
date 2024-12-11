// @file:Repository("https://maven.pkg.jetbrains.space/public/p/kotlinx-html/maven")
@file:DependsOn("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.9.0")

import java.math.BigInteger
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

suspend fun blinkEl(n: Int, stone: BigInteger): Long {
    print(n)
    print(" ")
    if (n == 0) return 1
    if (stone == BigInteger.ZERO) 
        if (n >= 4) return blink(n-4, flowOf(2, 0, 2, 4).map(Int::toBigInteger))
        else return blinkEl(n-1, BigInteger.ONE)
    val s = stone.toString()
    if (s.length.rem(2) == 0)
        return blink(n-1, s.chunked(s.length.div(2)).map(String::toBigInteger).asFlow())
    return blinkEl(n-1, stone * 2024.toBigInteger())
}

fun part1(input: List<BigInteger>) = runBlocking(Dispatchers.IO) { blink(25, input.asFlow()) }

fun part2(input: List<BigInteger>) = runBlocking(Dispatchers.IO) { blink(75, input.asFlow()) }

val inp = getInput()
println("Part 1: ${part1(inp)}")
println("Part 2: ${part2(inp)}")
