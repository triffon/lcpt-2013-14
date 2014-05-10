data Type = Base | Arrow Type Type
   deriving (Eq, Show)

idType :: Type
idType = Arrow Base Base

kType :: Type
kType = Arrow Base idType

data Term = Var Int | App Term Term | Lam Term
   deriving (Eq, Show)

i :: Term
i = Lam (Var 0)

k :: Term
k = Lam (Lam (Var 1))

s :: Term
s = Lam (Lam (Lam (App (App (Var 2) (Var 0)) (App (Var 1) (Var 0)))))

type TermFamily = Int -> Term

data Value = Object TermFamily | Function (Value -> Value)
   deriving Eq

x :: Int -> TermFamily
x n k = Var (k - n) -- би трябвало max(k - n, 0), но при коректно използване винаги k ≥ n

vf :: Value -> Value
vf (Object a) = Object a
vf (Function g) = g (Object (x 4))

v :: Value
v = Function vf

type Valuation = [Value]
δ :: Valuation
δ = map (\i -> Object (x i)) [0 .. 5]

value :: Term -> Valuation -> Value
value (Var i) ξ = ξ !! i
value (App m n) ξ = g (value n ξ)
  where Function g = value m ξ
value (Lam m) ξ = Function (\a -> value m (a:ξ))

kv :: Value
kv = value k δ

app :: TermFamily -> TermFamily -> TermFamily
app f1 f2 k = App (f1 k) (f2 k)

reify :: Type -> TermFamily -> Value
reify Base f = Object f
reify (Arrow ρ σ) f = Function (\a -> reify σ (app f (reflect ρ a)))

reflect :: Type -> Value -> TermFamily
reflect Base (Object f) = f
reflect (Arrow ρ σ) (Function g) =
    \k -> Lam ((reflect σ (g (reify ρ (x (k + 1))))) (k + 1))

nbe :: Type -> Term -> Term
nbe τ m = reflect τ (value m []) 0

iter :: Int -> Int -> Int -> Term
iter 0 f x = Var x
iter n f x = App (Var f) (iter (n - 1) f x)

c :: Int -> Term
c n = Lam (Lam (iter n 1 0))

c5 :: Term
c5 = c 5

numType :: Type
-- (α => α) => α => α
numType = Arrow (Arrow Base Base) (Arrow Base Base)

plus :: Term
-- plus = \n m f x -> n f (m f x)
plus = Lam (Lam (Lam (Lam (App (App (Var 3) (Var 1))
                          (App (App (Var 2) (Var 1)) (Var 0))))))

-- nbe idType (App (App s k) k)
-- Lam (Var 0) ≡ i

-- nbe numType (App (App plus (c 5)) (c 8))
{- Lam (Lam (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1)
            (App (Var 1) (Var 0)))))))))))))))
   ≡ c 13
-}
