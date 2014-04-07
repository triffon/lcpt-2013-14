:- op(150, xfx, ⊢).
:- op(145, xfx, ≡).
:- op(140, xfx, :).
:- op(140, xfx, ::).
:- op(120, xfy, ==>).
:- op(120, xfy, =>).
:- op(100, yfx, $$).
:- op(100, yfx, $).
:- op(100, xfx, @).
:- set_prolog_flag(occurs_check, true).

/* TL==>ρ ≡ τ */

[] ==> T ≡ T.
[X | TL] ==> T  ≡    (X => Y)    :-    TL ==> T   ≡   Y.

X $$ [] ≡ X.
M $$ [ N | Terms ] ≡ T :- (M $ N) $$ Terms ≡ T.

_ @ _  ⊢ [] :: [].
V @ Γ ⊢ [ Term | Terms ]   :: [ T | Types ] :- V @ Γ ⊢ Term : T, V @ Γ ⊢ Terms :: Types.

V @ _ ⊢ _ : T       :- member(T, V), !, fail.
_ @ Γ ⊢ X : T           :- member(X : T, Γ).
V @ Γ ⊢ λ(X,M) : S => T :- V @ [ X : S | Γ ] ⊢ M : T.
V @ Γ ⊢ App : S         :- member(X : T, Γ),
	               /* Ако намерим аргументи M1, M2, ..., Mn на X така че да се 
	                  получи тип S, тогава X M1 M2 ... Mn обитава S.
	                  Трябва да проверим дали T е от вида T₁=>T₂=>...T_n=>S*/
		       Types ==> S ≡ T,
		       /* TL е списък от типове */
		       [S | V] @ Γ ⊢ Terms :: Types,
		       /* трябва да приложим X над всеки един от термовете в TermList */
		       X $$ Terms ≡ App.
		       
