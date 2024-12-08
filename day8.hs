import qualified Data.Map as Map
import Data.List (nub, permutations)
import Control.Applicative (liftA3)

type InputMap = Map.Map Char [(Int, Int)]
data Input = Input Int Int InputMap

perms :: [a] -> [(a, a)]
perms = map (\(a:b:_) -> (a,b)) . permutations

indexed :: [a] -> [(Int, a)]
indexed = zip [0..]

ifoldr :: (Int -> a -> b -> b) -> b -> [a] -> b
ifoldr f z = foldr (\(i,x) -> f i x) z . indexed

if' :: Bool -> a -> a -> a
if' True x _ = x
if' False _ y = y

parseInput :: String -> Input
parseInput = (liftA3 Input length (length . head) $ ifoldr (
            \i -> flip $ ifoldr (
                \j c m -> if' (c == '.') m $ Map.insert c ((i,j):(Map.findWithDefault [] c m)) m
            )
        ) Map.empty) . lines

getInput :: IO Input
getInput = parseInput <$> getContents

inbounds :: Int -> Int -> Int -> Int -> Bool
inbounds h w i j = i >= 0 && i < h && j >= 0 && j < w

solve :: ((Int, Int) -> (Int, Int) -> [(Int, Int)]) -> Input -> Int
solve f (Input h w m) = length $ filter (
        uncurry $ inbounds h w
    ) $ nub $ concatMap (
        concatMap (uncurry f) . perms
    ) $ Map.elems m

part1 :: Input -> Int
part1 = solve (\(i1, j1) (i2, j2) -> [(i2+i2-i1,j2+j2-j1), (i1+i1-i2,j1+j1-j2)]) 

part2 :: Input -> Int
part2 (Input h w m) = solve (
        \(i1, j1) (i2, j2) -> (points (i2-i1, j2-j1) (i2, j2)) ++ (points (i1-i2, j1-j2) (i1, j1))
    ) (Input h w m)
    where
        points (di, dj) (i, j) = if inbounds h w i j
            then (i, j):(points (di, dj) (i+di, j+dj)) else []

main = do
    input <- getInput
    putStr "Part 1: "
    print $ part1 input
    putStr "Part 2: "
    print $ part2 input
