; (define Y (lambda (f) ((lambda (x) (f (x x)))
;                        (lambda (x) (f (x x))))))
; ^ Забива!!!

(define Y (lambda (f) ((lambda (x) (lambda (y) ((f (x x)) y)))
		       (lambda (x) (lambda (y) ((f (x x)) y))))))

(define F (lambda (f) (lambda (x) (if (= x 0) 1 (* (f (- x 1)) x)))))
(define fact (Y F))
(fact 10)