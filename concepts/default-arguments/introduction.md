# Introduction

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
