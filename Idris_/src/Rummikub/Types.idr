module Rummikube
-- Quick and dirty notes of Idris for a programming meetup.
--
-- Walking a bunch of dirty Java developers (like myself T_T)
-- through ever increasingly refined type constraints.

import Data.Vect

--=========================================
--              OPENING QUOTE
--=========================================
-- "Never believe that anything is obvious
--  until you write a proof of it."
               -- Leslie Lamport


--==========================================
--    A SUPER QUICK TOUR OF IDRIS Part I
--              Data Types
--==========================================

------------------
-- Enumerated Types
-------------------
data Color = Red | Black | Blue | Yellow
--  |-----| |-------------------------|
--   Type         Data Constructors



-----------------------------------------------
--                Union Types
-----------------------------------------------

-- Just like enumerations, but the data constructors
-- take arguments
data Shape
  = Square Int
  | Rectange Double Double
  | Circle Double
  | NoShape
-- Note that each constructor can have 0..N arguments
-- of any relevant type.



-----------------------------------------------
--             Recursive Types
-----------------------------------------------
-- We can define types that recursively
-- reference themselves.

data DuckDuckGoose = Duck DuckDuckGoose | Goose

playing1 : DuckDuckGoose
playing1 = Duck (Duck Goose)

playing2 : DuckDuckGoose
playing2 = Duck (Duck (Duck (Duck Goose)))



-----------------------------------------------
--             Generic Types
-----------------------------------------------
-- We can define types that are parameterized over
-- some other type. The canonical example being the
-- humble list.
-- Note that just like the above example, List is defined
-- in terms of itself.

data MyList a = MNil | MCons a (MyList a)
--  |--------|
--       |
-- This part is called a "Type Constructor"
-- contrast that with the Right Hand Side, which are **Data Constructors**
-- This disctinction will become important as we get further along.

-- Examples
listOfStrings : MyList String
listOfStrings = MCons "a" (MCons "b" MNil)
-- The language of course provides sugar for collections
-- When not using the raw data constructors, this would
-- look like [1,2]
listOfInt : MyList Int
listOfInt = MCons 1 (MCons 2 MNil)


--               New Syntax!
-----------------------------------------------
--                 "GADT"
--      Generalized Algebraic Data Type
-----------------------------------------------
-- All of the above can be expressed in a more expressive
-- way called Generalized Algebraic Data Types
-- This lays bare the machinery and types
data NewColors : Type where
  Violet : NewColors
  Green : NewColors

-- Same for union types and so on
data NewShape : Type where
  Square2 : (x : Int) -> NewShape
  Rectange2 : (width : Double) -> (height: Double) -> NewShape


data ListS : Type -> Type where
  NilS : ListS a
  ConsS : a -> ListS a -> ListS a


listEx2 : ListS String
listEx2 = (ConsS "1sdf" NilS)

----------------------------------------------
--             Dependent Types!
-----------------------------------------------
-- We climb one step higher into dependent types!
data MyVect : (n : Nat) -> (a : Type) -> Type where
  VNil : MyVect n a
  VCons : a -> MyVect n a -> MyVect (S n) a
--                    ^                ^
--                    |   Magic here   |
-- Explain Nat in brief


-- demo changing the N
-- or changing how big the vector is
vectExample : MyVect 2 String
vectExample = VCons "Hello" (VCons "World" VNil)
-- Brief intro to how these data constructors are
-- proof to the compiler that the type is valid.
-- We'll build on this idea a lot.




--   _______                            _____           _
--  |__   __|                          |  __ \         (_)
--     | |     _   _   _ __     ___    | |  | |  _ __   _  __   __   ___   _ __
--     | |    | | | | | '_ \   / _ \   | |  | | | '__| | | \ \ / /  / _ \ | '_ \
--     | |    | |_| | | |_) | |  __/   | |__| | | |    | |  \ V /  |  __/ | | | |
-- ____|_|     \__, | | .__/   \___|   |_____/  |_|    |_|   \_/    \___| |_| |_|_
-- |  __ \       __/ | | |        | |                                            | |
-- | |  | |   __|___/  |_|   ___  | |   ___    _ __    _ __ ___     ___   _ __   | |_
-- | |  | |  / _ \ \ \ / /  / _ \ | |  / _ \  | '_ \  | '_ ` _ \   / _ \ | '_ \  | __|
-- | |__| | |  __/  \ V /  |  __/ | | | (_) | | |_) | | | | | | | |  __/ | | | | | |_
-- |_____/   \___|   \_/    \___| |_|  \___/  | .__/  |_| |_| |_|  \___| |_| |_|  \__|
--                                         | |
--                                         |_|


-- The basic rules of Rummikube
-- TL;DR: It's rummy but with tiles
--  * Tiles have a rank of 1-13
--  * Tiles come in 4 different colors (red, black, yellow, blue)
--  * There are 2 joker tiles
-- The goal of the game is to produce RUNS and GROUPS
--  * Groups are 3-4 tiles that have the same rank, but different colors
--  * Runs are 3+ tiles that have the same color, but contiguous ranks (1,2,3,4)



-- V1. Modeling Tiles
data Tile_V1 = MkTile_V1 Nat Color | Joker_V1

v1example : Vect 3 Tile_V1
v1example = [MkTile_V1 0 Red, MkTile_V1 0 Black, MkTile_V1 31 Blue]
--                                                          ^ Whoops!
-- Problems:
--   * The type is imprecise.
--   * It allows invalid states to be constructed






----------------------------------------------
--          Exaining the Fin Data Type
-----------------------------------------------
-- See UnderstandingFin.idr



-- Back to modeling:

data Tile_V2 = MkTile_V2 (Fin 13) Color | Joker_V2

v2example : Vect 3 Tile_V2
v2example = [MkTile_V2 0 Red, MkTile_V2 0 Black, MkTile_V2 12 Blue]
--                                                         ^ MUST be correct



-- But still some problems.
-- While we've got excellent guaranteed type safety while
-- constructing our data type, the type as a whole is geared towards
-- runtime interactions. Once constructed, we can only get its information
-- back out by pattern matching. And by the time we've made it that far in
-- the execution, we've lost entirely the ability to prove any properties
-- of our program.


-- Alternative modeling.
data Tile : (n : Nat) -> (c : Color) -> Type where
  MkTile : (rank : Fin 13) -> (c : Color) -> Tile (finToNat rank) c
  Joker : (rank : Fin 13) -> (c : Color) -> Tile (finToNat rank) c


-- talk about dependent typed properties.


-- Modeling business rules

data Run : Type where
  -- For similar reasons, we'll stick with the minimal case.
  Threebie : (Tile n c) -> (Tile (S n) c) -> (Tile (S (S n)) c) -> Run
--                 ^ ^            ^    ^            ^        ^
--                 n |            n+1  |            n+1+1!   |
--                   Color             Same!                 SAME!
--
-- Run through the depednent types here.



-- How the hard one.
data Group : (n : Nat) -> Type where
  -- For ease of example (and because I don't actually know how to generalize)
  -- we'll stick with two. My amatuer proofs for > 2 become wacky.
  TwoOfAKind : (c1 : Tile n x) -> (c2 : Tile n y) -> (Not (x = y)) -> Group n
--                                                      ^ What is this!
--

e1 : Group 10
e1 = TwoOfAKind (MkTile 10 Red) (MkTile 10 Black) (\x : (Red = Black) => case x of Refl impossible)

-- Large digression on equality in Idris vs equality everywhere else
