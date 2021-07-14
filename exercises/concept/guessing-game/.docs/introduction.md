# Introduction

## Multiple Clause Functions

Elixir facilitates **Open-Close Principle** practices by allowing functions to have multiple clauses, so instead of sprawling and hard-coded control-logic, pointed functions can be written to add/remove behavior easily.

Elixir offers _multiple function clauses_ and _guards_ to write:

```elixir
def number(n) when n == 7 do
  "Awesome, that's my favorite"
end
def number(_n) do
  "That's not my favorite"
end
```

At run-time, Elixir will test, from top to bottom of the source file, which function clause to invoke.

Variables that are unused should be prefixed with an underscore.

## Guards

Guards are used to prevent Elixir from invoking functions based on evaluation of the arguments by guard functions. Guards begin with the `when` keyword, followed by a boolean expression. Guard functions are special functions which:

- Must be pure and not mutate any global states.
- Must return strict `true` or `false` values.

A list of common guards can be found in the [Elixir documentation][kernel-guards]. It includes type checks, basic arithmetic, comparisons, and strictly boolean operators.

## Default Arguments

Functions may declare default values for one or more arguments. Let's consider this function:

```elixir
def number(n \\ 13), do: "That's not my favorite"
```

When compiled, Elixir creates a function definition for `number/0` (no arguments), and `number/1` (one argument).

If more than one argument has default values, the default values will be applied to the function from left to right to fill in for missing arguments.

If the function has more than one clause, the default arguments should be defined in a function header (a function without a body) before the function clauses:

```elixir
def number(n \\ 13)
def number(n) when n < 10, do: "Dream bigger!"
def number(n) when n > 100, do: "Not that big..."
```

[kernel-guards]: https://hexdocs.pm/elixir/master/Kernel.html#guards
