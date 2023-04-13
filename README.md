# nyt-digits-solver

A tiny project about generating solutions to the NYT's *Digits* daily math puzzle with Prolog.

## Digits

In *Digits*, players are given a set of six numbers of which they have to apply arithmetic operations ($+$, $-$, $\div$, $\times$) to in order to produce a target number (or yield a total as close to the number as possible; in the game, final score is a function of your distance). Numbers used to create new numbers cannot be used again; instead the new number can now be manipulated upon by any other (new) numbers.

E.g., the following puzzle:

<img src="digits_ex_94.png" alt="Digits example" style="zoom: 50%;" />

has the trivial solution $(4\times 25)-(1+5)=100-6=94$.

## Usage

The prolog predicate `solve_digits/2` takes in a list of operable digits (1, 2, 4, 5, 10, and 25 in the above example) and a target number (94 in the example). The predicate holds if it can find a combination of expressions that yield the target number, satisfying the game rules.

Solutions are often repeated, as an approach for finding unique solutions is not currently implemented, e.g. $(4\times 25)-(1+5)$ could be followed by $(25\times 4)-(1+5)$ since the first expressions are considered different in the current implementation.

Here's an example predicate call with the above example:

```prolog
?- solve_digits([1, 2, 4, 5, 10, 25], 94).
10+(4+5)+25*(1+2)         = 94
true .
```

and with a harder tier problem:

```prolog
?- solve_digits([3, 13, 19, 20, 23, 25], 456).
19*25-(23-(20-(3+13)))    = 456
true .
```

Note that pressing `;` instead of `.` will generate further (potentially duplicated) solutions.
