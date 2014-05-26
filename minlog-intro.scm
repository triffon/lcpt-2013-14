Welcome to Racket v5.3.6.

Minlog loaded successfully
> (add-pvar-name "A" (make-arity))
ok, predicate variable A: (arity) added
> (pf "A")
(mcons 'predicate (mcons (mcons 'pvar (mcons (mcons 'arity) (mcons -1 (mcons 0 (mcons 0 (mcons "A"))))))))
> (pp (pf "A"))
A
> (pf "A & A")
(mcons 'and (mcons (mcons 'predicate (mcons (mcons 'pvar (mcons #0=(mcons 'arity) (mcons -1 (mcons 0 (mcons 0 (mcons "A")))))))) (mcons (mcons 'predicate (mcons (mcons 'pvar (mcons #0# (mcons -1 (mcons 0 (mcons 0 (mcons "A")))))))))))
> (pp (pf "A -> A & A"))
A -> A & A
> (set-goal (pf "A -> A"))

-----------------------------------------------------------------------------
?_1:A -> A

> (assume "u")
ok, we now have the new goal 

  u:A
-----------------------------------------------------------------------------
?_2:A

> (use "u")
ok, ?_2 is proved.  Proof finished.
> (cdp)
.A by assumption u73
A -> A by imp intro u73
> 
