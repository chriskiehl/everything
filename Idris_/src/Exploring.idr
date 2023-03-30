module Exploring

import Data.Vect
import Data.Fin

data Color = Red | Black | Blue

implementation Show Color where
  show Red = "Red"
  show Black = "Black"
  show Blue = "Blue"


data Card : (n : Nat) -> (c : Color) -> Type where
  MkCard : (rank : Fin 13) -> (c : Color) -> Card (finToNat rank) c

data SameRankDiffColor : (n : Nat) -> Type where
  MkGroupS : (c1 : Card n x) -> (c2 : Card n y) -> (Not (x = y)) -> SameRankDiffColor n



-- exampleGroup : TwoOfSameRank 3
-- exampleGroup = MkGroup (MkCard 2 Red) (MkCard 2 Black) (notEqColors Red Black)
--   where
--     notEqColors : (c1 : Color) -> (c2 : Color) -> Not (c1 = c2)
--     notEqColors Red Red = Void
--     notEqColors Black Black = Void
--     notEqColors _ _ = Refl



-- ex1 = MkGroup (MkCard 1 Red) (MkCard 1 Red)

-- data EqRank : (a : Card) -> (b : Card) -> Type where
--   Sameify : EqCard a a
--
--
-- e1 : EqCard (MkCard 2 Red) (MkCard 1 Red)
-- e1 = Sameify


-- data GroupOfTwo : (n : Nat) -> (c : Type) -> Type where
--   MkGroup : Card n c -> Card n c -> GroupOfTwo n c
--
-- -- makeGroup : {c : Color} -> {x : Nat} -> Card n c -> Card (S n) c
--
--
-- to : GroupOfTwo 1 Color
-- to = MkGroup (MkCard 13 Red) (MkCard 13 Red)

-- e1 : GroupOfTwo 0
-- e1 = MkGroup (MkCard FZ Red) (MkCard FZ Black)

data Tile = MkTile (Fin 13) Color


-- data DiffColorVect : List Color -> Type where
--   DNil : DiffColorVect []
--   (::) : {c : Color} -> (x : c) -> Not (Elem c xs) -> DiffColorVect xs -> DiffColorVect (c :: xs)


data Foo = MkFoo Nat

-- data ThreeOfAKind : Type where
--   MkThreeOfAKind : {n : Nat} -> Foo n -> Foo (S n) -> Foo (S (S n)) -> ThreeOfAKind

-- makeThreeOfAKind : Nat -> Nat -> Nat -> Maybe ThreeOfAKind
-- makeThreeOfAKind x y z with (ltEq x y, ltEq y z)
-- makeThreeOfAKind x y z | (Yes _, Yes _) = Just (ThreeOfAKind (MkFoo x) (MkFoo y) (MkFoo z))
-- makeThreeOfAKind _ _ _ = Nothing

-- doSomething : (x : Color) -> Card n  -> Card -> Card = String
-- doSomething (MkCard x c) = show c


-- data EqColor : (c : Color) -> (d : Color) -> Type where
--   Samezies : EqColor c c
--
-- data FixedColorVect : (c : Color) -> (n : Nat) -> Type where
--   Nil : FixedColorVect c Z
--   (::) : (x : Color) -> FixedColorVect x n -> FixedColorVect x (S n)

-- data ColorVect : Color -> Nat -> Type where
--   Nil : ColorVect c Z
--   (::) : x -> ColorVect x n -> ColorVect x (S n)



-- data ColorVect : (c : Color) -> Nat -> Type where
--   Nil : ColorVect c Z
--   (::) : {c : Color} -> c -> ColorVect c n -> ColorVect c (S n)

-- data FixedRankVect : (t : Tile) -> (n : Nat) -> Type where
--   Nil : FixedRankVect c Z
--   (::) : (x : Tile) -> FixedRankVect x n -> FixedRankVect x (S n)
--
--
-- allWhatever : ColorVect Color 2
-- allWhatever = [Red, White]


foo : Vect 2 Tile
foo = [MkTile 1 Red, MkTile 3 Black]
--
-- notAllWhite : ColorVec White 3
-- notAllWhite = WhiteType :: BlackType :: WhiteType :: Nil
