:- op(150, xfx, ⊢).
:- op(145, xfx, ≡).
:- op(140, xfx, :).
:- op(140, xfx, ::).
:- op(120, xfy, ==>).
:- op(120, xfy, =>).
:- op(100, yfx, $$).
:- op(100, yfx, $).
:- set_prolog_flag(occurs_check, true).

/* TL==>ρ ≡ τ */

[] ==> T ≡ T.
[X | TL] ==> T  ≡    (X => Y)    :-    TL ==> T   ≡   Y.

X $$ [] ≡ X.
M $$ [ N | Terms ] ≡ T :- (M $ N) $$ Terms ≡ T.

_ ⊢ [] :: [].
Γ ⊢ [ Term | Terms ]   :: [ T | Types ] :- Γ ⊢ Term : T, Γ ⊢ Terms :: Types.

Γ ⊢ X : T           :- member(X : T, Γ).
Γ ⊢ λ(X,M) : S => T :- [ X : S | Γ ] ⊢ M : T.
Γ ⊢ App : S         :- member(X : T, Γ),
	               /* Ако намерим аргументи M1, M2, ..., Mn на X така че да се 
	                  получи тип S, тогава X M1 M2 ... Mn обитава S.
	                  Трябва да проверим дали T е от вида T₁=>T₂=>...T_n=>S*/
		       Types ==> S ≡ T,
		       /* TL е списък от типове */
		       Γ ⊢ Terms :: Types,
		       /* трябва да приложим X над всеки един от термовете в TermList */
		       X $$ Terms ≡ App.
		       

