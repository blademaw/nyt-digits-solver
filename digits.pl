% tiny solver for the NYT's Digits daily math puzzle
:- use_module(library(pairs)).

solve_digits(Nums, Result) :-
  expr(Nums, 0, Result, Expr),
  % classify(Expr, Tree),
  format('~w~25| = ~w~n', [Expr, Result]).
  % format('~w~25| = ~w; ~w~n', [Expr, Result, Tree]).

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

%% EXPERIMENTAL -- GENERATING UNIQUE SOLUTIONS

% currently extremely inefficient.
% I think partly becuase of get_tree/4, but also fitlering? builds insane
% number of combinations and then filters => should filter when building.
solve_digits_unique(Nums, Target) :-
  setof(Expr-Tree, get_tree(Nums, Target, Expr, Tree), Sols),
  prune_list(Sols, [], UniqueSols),
  pairs_keys(UniqueSols, Keys),
  member(Sol, Keys),
  format('~w~25| = ~w~n', [Sol, Target]).

% misnomer: not actually a tree, but gets a list of operations on cumulative
% values performed by the expression generated
get_tree(Nums, Result, Expr, Tree) :-
  expr(Nums, 0, Result, Expr),
  classify(Expr, Tree).

% prunes a list of solutions in [Expression-Operations|...] format
prune_list([], A, A).
prune_list([Expr-Tree|Others], Acc, Res) :-
  ( pairs_values(Acc, Trees), member(Tree, Trees) ->
    prune_list(Others, Acc, Res)
  ; append([Expr-Tree], Acc, NewAcc),
    prune_list(Others, NewAcc, Res)
  ).

% turns an expression into a list of operations
classify(Expr, Res) :-
  classify_type(Expr, A, B, T),
  classify_op(A, B, T, [], ResPre),
  sort(ResPre, Res).

% classify_type/4 extracts the most immediate operation
classify_type(A/B, A, B, 3).
classify_type(A*B, A, B, 2).
classify_type(A+B, A, B, 0).
classify_type(A-B, A, B, 1).

classify_op(A, B, Type, Acc, Ops) :-
  ( A = 0, B = 0, Type = null ->
    Ops = Acc
  ;
  (integer(A), integer(B), sort([A, B], S) ->
    NewA = 0, NewB = 0, NewType = null,
    CurOps = [Type-S]
  ; integer(A) ->
    EvalB is B,
    sort([A, EvalB], S),
    classify_type(B, NewA, NewB, NewType),
    CurOps = [Type-S]
  ; integer(B) ->
    EvalA is A,
    sort([EvalA, B], S),
    classify_type(A, NewA, NewB, NewType),
    CurOps = [Type-S]
  ; EvalA is A,
    EvalB is B,
    sort([EvalA, EvalB], S),
    classify_type(A, LeftA, LeftB, LeftType),
    classify_op(LeftA, LeftB, LeftType, [], NewOps),
    append([Type-S], NewOps, CurOps),
    classify_type(B, NewA, NewB, NewType)
  ),
  append(CurOps, Acc, NewAcc),
  classify_op(NewA, NewB, NewType, NewAcc, Ops)).
