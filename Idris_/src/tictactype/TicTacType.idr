module TicTacType


import Data.Fin
import Data.Vect

data Piece = X | O

data Lens s a = L (s -> a) (a -> s -> s)

data Composition : (b -> c) -> (a -> b) -> a -> Type where
  Comp : (f . g) x -> (Composition f g) x

-- accessors for the components of the lens data type
-- could just as well be a tuple with fst & scd
getter : Lens s a -> s -> a
getter (L getter _) = getter

setter : Lens s a -> a -> s -> s
setter (L _ setter) = setter




vectorL : Fin n -> Lens (Vect n a) a
vectorL index = L (get index) (set index) where
  get : Fin n -> Vect n a -> a
  get FZ (v :: vs) = v
  get (FS m) (v :: vs) = get m vs

  set : Fin n -> a -> Vect n a -> Vect n a
  set FZ a (_ :: vs) = a :: vs
  set (FS m) a (v :: vs) = v :: (set m a vs)


tail : Vect (S n) a -> Vect n a
tail (x :: xs) = xs


ticTacTerrific : Type
ticTacTerrific = Vect 3 (Vect 3 (Maybe Piece))


main : IO ()
main = putStrLn "Hello World!"
