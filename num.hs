-- Нумерали на Чърч

c 0 = \f x -> x
-- c 1 = \f x -> f x
-- c 2 = \f x -> f (f x)
c n = \f x -> f (c (n-1) f x)

c5 = c 5

-- c5 (+1) 0 ---> 5
-- c5 (+2) 3 ---> 5 * 2 + 3 = 13

printnum c = c (+1) 0

-- printnum c5 ---> 5
-- printnum (c n) ---> n

s = \n f x -> f (n f x)
-- printnum (s (c 20)) ---> 21

plus = \n m f x -> n f (m f x)
-- printnum (plus (c 2) (c 3)) ---> 5

mult = \n m f x -> n (m f) x
-- printnum (mult (c 2) (c 3)) ---> 6

ifthenelse = \x -> x

true = \x y -> x
false = \x y -> y

printbool b = b True False

iszero = \n -> n (\x -> false) true
-- printbool (iszero (c 0)) ---> True
-- printbool (iszero (c 10)) ---> False

cons = \x y b -> b x y

car = \z -> z true
cdr = \z -> z false

printnumpair z = (printnum (car z), printnum (cdr z))

z34 = cons (c 3) (c 4)

-- printnumpair z34 ---> (3,4)

p = \n -> cdr (n (\z -> cons (s (car z)) (car z)) (cons (c 0) (c 0)))
-- printnum (p (c 10)) ---> 9

-- "фалшива" реализация на Y комбинатора
-- чрез вградената рекурсия на Haskell
-- понеже директната дефиниция не е типизируема
y f = f (y f)

-- не можем да реализираме рекурсивен оператор дефиниращ f(x) = x!
-- понеже директната дефиниция не е типизируема!!!
-- но иначе би изглеждала подобно на това:
-- factop = \f x -> (iszero x) (c 1) (mult x (f (p x)))
-- fact = y factop