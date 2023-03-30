module Rummikube

import Data.Vect
import Debug.Trace


data Color = Red | Black | Blue | Yellow

data Card : (n : Nat) -> (c : Color) -> Type where
  MkCard : (rank : Fin 13) -> (c : Color) -> Card (finToNat rank) c
  -- I don't love this, but I can squint and justify it as "jokers take on
  -- the value of the surrounding context" and thus, they DO have a rank
  -- and suite associatated with them. However, it definitely feels crummy.
  Joker : (rank : Fin 13) -> (c : Color) -> Card (finToNat rank) c


data Group : (n : Nat) -> Type where
  TwoOfAKind : (c1 : Card n x) -> (c2 : Card n y) -> (Not (x = y)) -> Group n
  ThreeOfAKind : (c1 : Card n x) -> (c2 : Card n y) -> (c3 : Card n z) -> (Not (x = y)) -> (Not (x = z)) -> (Not (z = y))-> Group n


data Run : Type where
  Three : (Card n c) -> (Card (S n) c) -> (Card (S (S n)) c) -> Run


run1 : Run
run1 = Three (MkCard 2 Red) (MkCard 3 Red) (MkCard 4 Red)


data MyNat = SS MyNat | ZZ

-- g1 : MyNat
-- g1 = (SS (SS (SS ZZ)))

data ElemS : a -> Vect k a -> Type where
  HereS : ElemS x (x :: xs)
  ThereS : (later : ElemS x xs) -> ElemS x (y :: xs)

maryInVector : ElemS "Mary" ["Peter", "Paul", "Mary"]
maryInVector = ThereS (ThereS HereS)

infix 6 :::
data UniqueVect : Nat -> Type -> Type where
  Nill : UniqueVect 0 elem
  (:::) : elem -> UniqueVect len elem -> UniqueVect (S len) elem


asdf : UniqueVect 1 String
asdf = "hey" ::: Nill

-- asdfasf : (Red = Black) -> Void


e1 : Group 10
e1 = TwoOfAKind (MkCard 10 Red) (MkCard 10 Black) (\x : (Red = Black) => case x of Refl impossible)


e2 : Group 12
e2 = ThreeOfAKind
    (MkCard 12 Red)
    (MkCard 12 Black)
    (MkCard 12 Yellow)
    (\x : (Red = Black) => case x of Refl impossible)
    (\x : (Red = Yellow) => case x of Refl impossible)
    (\x : (Yellow = Black) => case x of Refl impossible)


evidence : (Not (Red = Black) = Not (Red = Yellow)) = Not (Yellow = Black)
evidence = ?evidence_rhs


-- e2 : Group 10
-- e2 = ThreeOfAKind (MkCard 10 Red) (MkCard 10 Black) (MkCard 10 Yellow) evidence


Name : Type
Name = String

-- record Player (size : Nat) where
--   constructor MkPlayer
--   name : Name
--   rack : Vect size Tile
--
-- data AllSameTile
--
--
-- -- must have 3-4 tiles
-- -- all same number
-- -- all different colors
-- data Group = ThreeGroup Tile Tile Tile
--            | FourGroup Tile Tile Tile Tile

-- must be all the same color
-- must be 3 or more tiles

-- data Run : (n : Nat) -> Type where
--   MkRun : Vect n Tile -> Run n


-- data Set = Runn | Groupp


-- record GameState where
--   constructor MkGameState
--   pool : Vect n Tile
--   inplay : Vect m Set
--   players : Vect 2 Player


-- meld : Player -> GameState -> GameState

--
--
-- -- draw : (n : Nat) -> Pool m -> Pool (m - n)
-- -- draw n p = ?pp
--
-- -- group all the same color,
-- -- data Group =
--
-- -- This took me a few hours to get the type system happy........


-- ||| Initialize the Pool of available tiles.
-- ||| This is effectively just a deck of 52 cards
-- initPool : Vect 106 Tile
-- initPool = tiles ++ tiles ++ jokers
--   where
--     colors : Vect 4 Color
--     colors = [Red, Black, Blue, Yellow]
--
--     numbers : Vect 13 (Fin 13)
--     numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
--
--     tiles : Vect 52 Tile
--     tiles = concat $ map (\n => map (\c => MkTile n c) colors) numbers
--
--     jokers : Vect 2 Tile
--     jokers = [Joker, Joker]
--
--
--
-- myRemoveElem : (value : a) -> (xs : Vect (S n) a) -> Vect n a
-- myRemoveElem value xs = ?rhs
