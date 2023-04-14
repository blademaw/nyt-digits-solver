% tiny solver for the NYT's Digits daily math puzzle

solve_digits(Nums, Result) :-
  expr(Nums, 0, Result, Expr),
  format('~w~25| = ~w~n', [Expr, Result]).

expr(Available, Cur, Result, Expr) :-
  ( EvalCur is Cur, EvalCur =:= Result ->
    Expr = Cur
  ; % otherwise, take two from available
    member(X, Available),
    member(Y, Available),
    X \= Y,
    transform(X, Y, NewExpr),
    select(X, Available, A1),
    select(Y, A1, A2),
    append(A2, [NewExpr], NewAvailable),
    expr(NewAvailable, NewExpr, Result, Expr)
  ).

transform(Expr1, Expr2, NewExpr) :-
  ( NewExpr = Expr1 + Expr2 ;
  NewExpr = Expr1 - Expr2 ;
  NewExpr = Expr1 * Expr2 ;
  NewExpr = Expr1 / Expr2 ),
  EvalNewNum is NewExpr,
  EvalNewNum > 0,
  integer(EvalNewNum).
