:- op(150, xfx, ⊢).
:- op(140, xfx, :).
:- op(140, xfx, ::).
:- op(135, xfx, ≡).
:- op(120, xfy, ==>).
:- op(120, xfy, =>).
:- op(100, yfx, $$).
:- op(100, yfx, $).
:- op(100, xfx, @).
:- set_prolog_flag(occurs_check, true).

/*
V @ Γ ⊢ Term $$ Terms ≡ M :: Types ==> Type ≡ T.
В контекст Γ със стек на историята V можем да изведем, че функцията Term, приложена над аргументи Terms,
  което всъщност е M, е от тип Type, което е резултат на функция от тип T приложена над аргументи от типове Types.
*/

_ @ _ ⊢ [] :: [].
_ @ _ ⊢ Term $$ [] ≡ Term :: [] ==> T ≡ T.
V @ Γ ⊢ M $$ [ N | Terms1 ] ≡ Term :: [ R | Types1 ] ==> T ≡ R => S :-
	  V @ Γ ⊢ (M $ N) $$ Terms1 ≡ Term :: Types1 ==> T ≡ S,
	  V @ Γ ⊢ N : R.


V @ _ ⊢      _ : T      :- member(T, V), !, fail.
V @ Γ ⊢ λ(X,M) : S => T :- V @ [ X : S | Γ ] ⊢ M : T.
V @ Γ ⊢    App : S      :- member(X : T, Γ), [S | V] @ Γ ⊢ (X $$ _ ≡ App) :: _ ==> S ≡ T.

inhabits(M, T)  :- [] @ [] ⊢ M : T.