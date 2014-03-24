-- Нумерали на Чърч

type Numeral t = (t -> t) -> t -> t

c :: Int -> Numeral t
c 0 = \f x -> x
-- c 1 = \f x -> f x
-- c 2 = \f x -> f (f x)
c n = \f x -> f (c (n-1) f x)

c5 :: Numeral t
c5 = c 5

-- c5 (+1) 0 ---> 5
-- c5 (+2) 3 ---> 5 * 2 + 3 = 13

printnum :: Numeral Int -> Int
printnum c = c (+1) 0

-- printnum c5 ---> 5
-- printnum (c n) ---> n

type Function t = Numeral t -> Numeral t

s :: Function t
s = \n f x -> f (n f x)
-- (printnum (s (c 20))) ---> 21

type BinaryFunction t = Numeral t -> Function t

plus :: BinaryFunction t
plus = \n m f x -> n f (m f x)
-- printnum (plus (c 2) (c 3)) ---> 5

mult :: BinaryFunction t
mult = \n m f x -> n (m f) x
-- printnum (mult (c 2) (c 3)) ---> 6

type Boolean t = t -> t -> t

ifthenelse :: Boolean t -> t -> t -> t
ifthenelse = \x -> x

true :: Boolean t
true = \x y -> x

false :: Boolean t
false = \x y -> y

printbool :: Boolean Bool -> Bool
printbool b = b True False

iszero :: Numeral (Boolean t) -> Boolean t
iszero = \n -> n (\x -> false) true
-- printbool (iszero (c 0)) ---> True
-- printbool (iszero (c 10)) ---> False

-- ВНИМАНИЕ: ето тук вече типът на iszero налага ограничения върху нумерала
-- върху който работи, а именно:
-- той ще може да бъде използван САМО за итерация над булеви стойности

type Pair t = Boolean t -> t
cons :: t -> t -> Pair t
cons = \x y b -> b x y

car :: Pair t -> t
car = \z -> z true

cdr :: Pair t -> t
cdr = \z -> z false

printnumpair :: Pair (Numeral Int) -> (Int,Int)
printnumpair z = (printnum (car z), printnum (cdr z))

z34 :: Pair (Numeral t)
z34 = cons (c 3) (c 4)

-- printnumpair z34 ---> (3,4)

p :: Numeral (Pair (Numeral t)) -> (Numeral t)
p = \n -> cdr (n (\z -> cons (s (car z)) (car z)) (cons (c 0) (c 0)))
-- printnum (p (c 10)) ---> 9

-- ВНИМАНИЕ: тук типът на p също налага ограничения върху нумерала
-- върху който работи, а именно:
-- нумералът може да бъде използван САМО за итерация над двойки от нумерали

-- "фалшива" реализация на Y комбинатора
-- чрез вградената рекурсия на Haskell
-- понеже директната дефиниция не е типизируема
y :: (t -> t) -> t
y f = f (y f)

-- не можем да реализираме рекурсивен оператор дефиниращ f(n) = n!
-- понеже директната дефиниция не е типизируема!!!
-- но иначе би изглеждала подобно на това:
-- factop = \f n -> (iszero n) (c 1) (mult x (n (p n)))
-- fact = y factop

-- проблемът е в това, че над n се налагат противоречиви типови ограничения:
-- p x налага ограничение, че n :: Numeral (Pair (Numeral t1))
-- iszero x налага ограничение, че n :: Numeral (Boolean t2)
-- можем да заобиколим това ограничение, като "симулираме" булеви стойности чрез
-- наредени двойки от нумерали. Например:
double :: Numeral t -> Pair (Numeral t)
double n = cons n n

pair_true :: Pair (Numeral t)
pair_true = double (c 1)

pair_false :: Pair (Numeral t)
pair_false = double (c 0)

pair_iszero :: Numeral (Pair (Numeral t)) -> Pair (Numeral t)
pair_iszero = \x -> x (\n -> pair_false) pair_true

pair_int :: Pair (Numeral Int) -> Int
pair_int = \b -> car b (+1) 0

pair_bool :: Pair (Numeral Int) -> Bool
pair_bool = \b -> pair_int b > 0

-- pair_bool pair_false ---> False
-- pair_bool pair_true ---> True
-- pair_bool (pair_iszero (c 0)) ---> True
-- pair_bool (pair_iszero (c 1)) ---> False

-- след това вече можем да дефинираме коректно типизирана, но "фалшива" функция 
-- описваща оператор дефиниращ факториел рекурсивно
-- като използваме вградения тип Int на Haskell
type NPNI = Numeral (Pair (Numeral Int))
factop_fake :: (Numeral Int -> NPNI) -> NPNI -> NPNI
factop_fake = \f n -> if pair_bool (pair_iszero n)
                      then c 1
                      else mult n (f (p n))

-- тук вече имаме друг проблем, понеже първият параметър
-- f не запазва типа на нумерала, който приема като аргумент
-- затова всъщност не е вярно, че f :: Function t
-- и съответно factop не пасва на шаблона t -> t
-- налага се да дефинираме "генерализираща" функция:

ni_to_any :: Numeral Int -> Numeral t
ni_to_any = \n -> c (printnum n)

factop_fakier :: (NPNI -> NPNI) -> NPNI -> NPNI
factop_fakier = \f n -> if pair_bool (pair_iszero n)
                      then c 1
                      else mult n (f (ni_to_any (p n)))

-- тогава вече може да дефинираме факториел рекурсивно!
fact :: NPNI -> NPNI
fact = y factop_fakier

-- само остава да успеем да "измъкнем" числото от нумерал от тип NPNI
-- за целта първо ще "смъкнем" типа от Numeral (Pair (Numeral t))
-- до Pair (Numeral t)
npn_to_pn :: Numeral (Pair (Numeral t)) -> Pair (Numeral t)
npn_to_pn = \n -> n (\x -> double (s (car x))) (double (c 0))

-- и след това можем да извадим числото от двойката с printnumpair.
-- така вече можем да дефинираме "отпечатваща" функция за NPNI
print_npni :: NPNI -> Int
print_npni npni = fst (printnumpair (npn_to_pn npni))

-- и вече можем да смятаме факториели!
-- print_npni (fact (c 7)) ---> 5040
