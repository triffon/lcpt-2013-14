{- Примери за типизиране на λ-термове -}
{- :t term ---> term :: Type -}

i = \x -> x
-- i :: t -> t

k = \x y -> x
-- k :: t1 -> t -> t1

s = \x y z -> x z (y z)
-- s :: (t2 -> t1 -> t) -> (t2 -> t1) -> t2 -> t

-- omega = \x -> x x
-- не е типизируем!

c3 = \f x -> f (f (f x))
-- c3 :: (t -> t) -> t -> t

