import scala.collection.mutable.PriorityQueue
import scala.collection.mutable.Set
import scala.io.StdIn.readLine
import scala.util.boundary

def getInput: List[(Int, Int)] =
    Iterator
        .continually(readLine)
        .takeWhile(_ != null)
        .map(_.split(",").map(_.toInt) match {
            case Array(x, y) => (x, y)
            case _ => throw new IllegalArgumentException("Invalid input format")
        })
        .toList

def dijkstra(obstacles: Set[(Int, Int)]): Int =
    val visited = Set.empty[(Int, Int)]
    val queue = PriorityQueue((0, (0, 0)))(
        using Ordering.by[(Int, (Int, Int)), Int](_._1).reverse
    )

    boundary[Int]: outer ?=>
        while (queue.nonEmpty)
            boundary: inner ?=>
                val (distance, (x, y)) = queue.dequeue()

                if (!visited.add((x, y)) || obstacles.contains((x, y)))
                    boundary.break()(using inner)

                if (x == 70 && y == 70) 
                    boundary.break(distance)(using outer)

                for (dx <- -1 to 1; dy <- -1 to 1 if Math.abs(dx) + Math.abs(dy) == 1)
                    val next = (x + dx, y + dy)

                    if (!visited.contains(next) && !obstacles.contains(next) && next._1 >= 0 && next._2 >= 0 && next._1 <= 70 && next._2 <= 70) 
                        queue.enqueue((distance + 1, next))

        -1

def part1(input: List[(Int, Int)]): Int =
    dijkstra(Set(input.take(1024)*))

def part2(input: List[(Int, Int)]): (Int, Int) =
    val obstacles = Set.empty[(Int, Int)]

    input.find(obstacles.add(_) && dijkstra(obstacles) == -1).getOrElse {
        throw new IllegalArgumentException("No impossible path found")
    }

@main
def main: Unit =
    val input = getInput
    println(s"Part 1: ${part1(input)}")
    println(s"Part 2: ${part2(input)}")
