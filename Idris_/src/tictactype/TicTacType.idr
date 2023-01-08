module TicTacType


import Data.Fin

data Piece = X | O

data Vector : Nat -> Type -> Type where
  Nil : Vector Z a
  (::) : a -> Vector n a -> Vector (S n) a



data Lens s a = L (s -> a) (a -> s -> s)

get : Lens s a -> s -> a
get (L g _) = g

set : Lens s a -> a -> s -> s
set (L _ s) = s



vectorL : Fin n -> Lens (Vector n a) a
vectorL index = L (get index) (set index) where
  get : Fin n -> Vector n a -> a
  get FZ (v :: vs) = v
  get (FS m) (v :: vs) = get m vs

  set : Fin n -> a -> Vector n a -> Vector n a
  set FZ a (_ :: vs) = a :: vs
  set (FS m) a (v :: vs) = v :: (set m a vs)


tail : Vector (S n) a -> Vector n a
tail (x :: xs) = xs


ticTacTerrific : Type
ticTacTerrific = Vector 3 (Vector 3 (Maybe Piece))


main : IO ()
main = putStrLn "Hello World!"
