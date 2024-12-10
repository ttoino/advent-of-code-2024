import Data.List
import Debug.Trace

parseInput : String -> List Int
parseInput = map ((flip (-) $ ord '0') . ord) . unpack

getInput : IO (List Int)
getInput = parseInput <$> getLine

sumSpan : Int -> Int -> Int
sumSpan a b = a * b + (b * (b - 1)) `div` 2

part1 : List Int -> Int
part1 inp = solveBlock 0 0 (cast (length inp) `div` 2) inp
    where
        solveBlock : Int -> Int -> Int -> List Int -> Int
        solveSpace : Int -> Int -> Int -> List Int -> Int

        solveBlock _ _ _ [] = 0
        solveBlock index idH idT (b::xs) =
            idH * (sumSpan index b)
            + solveSpace (index + b) (idH + 1) idT xs
        
        solveSpace _ _ _ [] = 0
        solveSpace _ _ _ (s::[]) = 0
        solveSpace index idH idT (s::xs) =
            idT * (sumSpan index ss)
            + ifThenElse (newLastEl == 0)
                (solveSpace (index + ss) idH (idT - 1) ((s - ss)::newList))
                (solveBlock (index + ss) idH idT (maybe [] id (init' xs) ++ [newLastEl]))
            where
                lastEl = last (s::xs)
                ss = min s lastEl
                newLastEl = lastEl - ss
                newList = maybe [] id $ init' =<< init' xs

part2 : List Int -> Int

elba : IO ()
elba = do
    input <- getInput
    putStr "Part 1: "
    printLn $ part1 input
    putStr "Part 2: "
    printLn $ part2 input
