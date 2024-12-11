⍝ Read the input
data ← {
    in ← 2 1⍴⍎⍵
    1000 0 :: in
    in,∇⍞
}⍞

⍝ Part 1
⎕ ← 'Part 1:' , +⌿|-⌿(⌷⍨)∘(⊂⍋)⍨⍤1⊢data

⍝ Part 2
⎕ ← 'Part 2:' , +⌿(1⌷data)(⊣×(≢(=⊢⍤/⊢)))¨⊂2⌷data
