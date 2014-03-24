(define (h x y)
  (if (< y 5)
      x
      (+ y 2)))

(define (g x) (g x))

; (h (g 0) 5) ---> забива