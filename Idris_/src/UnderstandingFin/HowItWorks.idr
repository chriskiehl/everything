module HowItWorks

import Data.Fin

-- Understanding the 3 lines of code that define Fin took me an
-- embarassing amount of time (literally more than a day...)
--
-- It seems I'm not totally alone in this level of stumpery
-- * https://www.hacklewayne.com/fin
-- * https://stackoverflow.com/questions/75045963/how-does-fin-know-not-to-go-past-its-type-bound/75048120#75048120
-- * https://groups.google.com/g/idris-lang/c/CUwxhmyOp_Y

-- It works just like Nat
-- data Nat = Z | S Nat
--
-- data Fin : (n : Nat) -> Type where
--   FZ : Fin (S k)
--   FS : Fin k -> Fin (S k)
--
-- except slightly backwards. In fact, in a very mind fucky way
-- it counts up (from a usage perpective) and down (from a bookkeeping
-- perspective) at the same time. Wot.
--
-- Superficial usage: it counts up just like Nat
-- 0 = FZ
-- 1 = FS FZ
-- 2 = FS (FS FZ)
-- etc...
--
-- However, because of how the type is defined. It counts *down*
-- via the `k` parameter. There is a shocking amount of stuff going
-- on here. All of which is mind expanding.
--
--  * Implicits
--  * The resultant type being dependent on the input
--
-- 1. What tf is `k` and where does it come from?
-- -------------------------------------------
-- It's an implicit parameter. The compiler figures out the only possible
-- value that it could have and automatically appies it.
-- This is the first bit of fuckiness.
--
-- 2. FZ : Fin (S k)
-- -----------------
-- This is where it gets hard to even form sentences that make sense
-- and don't decend into tautology.
-- To create an FZ of type `Fin n`, the `k` must be less than n, because
-- its resultant type is `(S k)` e.g. k + 1. If k == n, then k would become
-- greater than n, and the type `Fin n` would no longer be valid. So, the compiler
-- infers that there exists exactly possible value k could have
t0 : Fin 2
t0 = FZ
-- this can ONLY be k = 1
-- We can see this by making the implicit argument explicit
t0_ : Fin 2
t0_ = FZ {k = 1}
-- if you put in anything else, it wouldn't compile!
-- Why? Because in order for `FZ` to have the type `Fin 2`
-- it MUST have `k=1`, which gets wrapped in `(S k)`, which
-- increments the value and thus causes the type to satisfy `Fin 2`

-- This logic holds for all possible values of Fin.
t1 : Fin 10
t1 = FZ -- what would `k` *HAVE* to be in order to produce the right type?
-- 9!
t1_ : Fin 10
t1_ = FZ {k=9}
-- Again, we can repeat the exercise. Anything other than 9 would cause
-- the wrong final type. e.g.
-- t1 : Fin 10
-- t1 = FZ {k=8}  <-- this would say that the type = Fin 9, which is wrong.
--
-- The big thing to realize here is that is counting something completely different
-- from what the values represent. We will always cound FZ as 0, but its internal
-- type parameter can have completely different and disconnected values.
-- The compiler infering the _one value that makes sense for k_, and that that value
-- has absolutely NOTHING to do with the (FS (FS FZ)) is the abolsute crucial insight required
-- in order to understand how this all works.
--
-- This becomes clearer (and initially trippier) once we consider FS:
--
--
-- 3. `FS : Fin k -> Fin (S k)`
-- ---------------------------------------------------------
-- The base case is pretty easy. Now the real fuckiness starts.
-- FS takes a `Fin k` and, just like FZ, yields a type where k in increased by 1
--
-- When I look at this, the main thing I didn't get is why it doesn't count
-- UP (just like the Nats). We're giving it a k and "producing" a k+1. How in
-- the world is this bound by `n`?
-- This gets into a type of recursive thinking and compiler solving that I
-- haven't encountered before. You've got to think backwards and forwards at the
-- same time in order to compute what the values should be.
-- This is where we get into recursive tautologies..
-- FS : Fin k -> Fin (S k)
-- FS takes a Fin k and yields a type of Fin (S k).
-- Just like in the FZ case, this means that FS *must* have a `k` value of `n-1`.
-- That's the ONLY value that produces the correct type.
-- But! To construct a FS, you have a provide another Fin k. This is where we get
-- into the "thinking recursively backwards" bit.
-- FS : Fin k -> Fin (S k)
-- To build an FS, we need another Fin k.
-- Starting with just Fin 2, we is pretty easy
t2 : Fin 2
t2 = FS FZ
-- The outer most FS MUST equal n - 1 in order to type check
t2_ : Fin 2
t2_ = FS {k=1}  (FZ {k=0})
-- this is true no matter the size of n
t2__ : Fin 4
t2__ = FS {k=3} (FZ {k=2})
-- even if it's crazy big
t2___ : Fin 401
t2___ = FS {k=400} (FZ {k=399})
-- because, again, weirdly mind bendingly, this is the only possible value k could have!
--
-- Now, at this point, things should be starting to come into focus. However, the recursion
-- can still be fucky. When I made it here, I was still confused about how, when you've got
-- a series of FS (FS (FS FZ)), the FZ is 'allowed' to have k values like 2, or 399, or
-- anything other than `Fin (n-1)`. And the simple answer is that it IS resolving to n-1, but
-- for a different N! Each time we recurse, the N gets smaller. This is very, very obvious once it
-- clicks but can be subtle until all the pieces fall into place.
--
-- a larger example:
t3 : Fin 4
t3 = (FS (FS (FS FZ)))

t3_ : Fin 4
t3_ = (FS {k=3} (FS (FS FZ)))

-- 4. How does the bounding work?
-- ------------------------------
-- This bounding naturally falls out from everything above.
-- Let's purposefully create an invalid Fin
-- This would not compile:
-- ```
-- t4 : Fin 2
-- t4 = (FS (FS FZ))
-- ```
--
-- The exists ONE k value for FS which satisfies the type `Fin 2`: k=1
-- So the compiler plugs it into the outer most FS
-- t4 : Fin 2
-- t4 = (FS {k=1} (FS FZ)
-- bit this creates an impossible state!
--
-- t4 : Fin 2
-- t4 = (FS {k=1} (FS {k=0} (FZ {k = INVALID}))
-- There is no Nat below zero! It's not something that's even possible
-- to express.
-- THIS is how the bounding in Fin works.
