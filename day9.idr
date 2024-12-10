import Data.List

Integral Nat where
    div x y = fromInteger $ cast x `div` cast y
    mod x y = fromInteger $ cast x `mod` cast y

Filesystem = List (Maybe Nat, Nat)

indexed : List a -> List (Nat, a)
indexed list = zip [0..(length list)] list

parts : (l: List a) -> {auto 0 _ : NonEmpty l} -> (List a, a)
parts l = (init l, last l)

parseInput : String -> Filesystem
parseInput = map (
        bimap (
            \i => ifThenElse (i `mod` 2 == 1) Nothing (Just $ i `div` 2)
        ) (
            cast . (flip (-) $ ord '0') . ord
        )
    ) . indexed . unpack

getInput : IO Filesystem
getInput = parseInput <$> getLine

sumSpan : Nat -> Nat -> Nat
sumSpan a b = a * b + (b * (b `minus` 1)) `div` 2

checksum : Filesystem -> Nat
checksum = fst . foldl (
        \(acc, i) => \(id, size) => (acc + sum id * (sumSpan i size), i + size)
    ) (0, 0)

part1 : Filesystem -> Nat
part1 = checksum . solve
    where
        solve : Filesystem -> Filesystem
        solve [] = []
        solve ((Just id, size)::xs) = (Just id, size) :: solve xs
        solve ((Nothing, 0)::xs) = solve xs
        solve ((Nothing, _)::[]) = []
        solve ((Nothing, size)::xs@(_::_)) = let (i, l) = parts xs in case l of
            (Nothing, _) => solve $ (Nothing, size) :: i
            (Just _, 0) => solve $ (Nothing, size) :: i
            (Just id, size') => let s = min size size' in
                (Just id, s) :: (solve $ (Nothing, size `minus` s) :: i ++ [(Just id, size' `minus` s)])

part2 : Filesystem -> Nat
part2 = checksum . reverse . solve . reverse
    where
        solve : Filesystem -> Filesystem
        solve [] = []
        solve ((Nothing, size)::xs) = (Nothing, size) :: solve xs
        solve ((Just id, size)::xs) = maybe ((Just id, size) :: solve xs) ((::) (Nothing, size) . solve . reverse) . replace . reverse $ xs
            where
                replace : Filesystem -> Maybe Filesystem
                replace [] = Nothing
                replace ((Just id', size')::xs) = [(Just id', size') :: ys | ys <- replace xs]
                replace ((Nothing, size')::xs) = ifThenElse (size' >= size)
                    (Just $ (Just id, size)::(Nothing, size' `minus` size)::xs) 
                    [(Nothing, size') :: ys | ys <- replace xs]

elba : IO ()
elba = do
    input <- getInput
    putStr "Part 1: "
    printLn $ part1 input
    putStr "Part 2: "
    printLn $ part2 input
