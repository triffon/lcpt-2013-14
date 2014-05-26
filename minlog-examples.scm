(add-pvar-name "A" (make-arity))

(set-goal (pf "A -> A & A"))
(assume "u")
(split)
(use "u")
(use "u")
(cdp)

(add-pvar-name "B" (make-arity))

; K
(set-goal (pf "A -> B -> A"))
(assume "u")
(assume "v")
(use "u")
(cdp)

; S
(add-pvar-name "C" (make-arity))
(set-goal (pf "(A -> B -> C) -> (A -> B) -> A -> C"))
(assume "u" "v" "w")
(use "u")
(use "w")
(use "v")
(use "w")
(cdp)

; слаба дизюнкция към силна дизюнкция
(set-goal (pf "A ord B -> (A -> bot) -> (B -> bot) -> bot"))
(assume "u" "v" "w")
(elim "u")
(use "v")
(use "w")
(cdp)

; закон на de Morgan
(set-goal (pf "((A ord B) -> bot) -> ((A -> bot) & (B -> bot))"))
(assume "u")
(split)
  (assume "v")
  (use "u")
  (intro 0)
  (use "v")
  ; done
  (assume "v")
  (use "u")
  (intro 1)
  (use "v")
  ; done
; done
(cdp)

; закон на Peirce
(set-goal (pf "((A -> B) -> A) -> A"))
(assume "u")
(use "StabLog")
(assume "v")
(use "v")
(use "u")
(assume "w")
(use "EfqLog")
(use "v")
(use "w")
(cdp)

(add-var-name "x" (py "alpha"))
(add-pvar-name "D" (make-arity (py "alpha")))

; закон на de Morgan за ∀ и ∃
(set-goal (pf "(exd x (D x) -> bot) -> all x ((D x) -> bot)"))
(assume "u")
(assume "x")
(assume "v")
(use "u")
(intro 0 (pt "x"))
(use "v")
(cdp)
