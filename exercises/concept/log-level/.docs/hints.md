# Hints

## General

- The [atom type is described here][atom].

## 1. Return the logging code label

- You can use the [`cond/1` special form][cond] to elegantly handle the various log codes.
- You can use [equality operators][equality] to compare integers for strict type equality.
- There is a [way to specify a default branch][cond] in a cond expression that can be used to catch unspecified cases.

## 2. Send an alert

- You can use the [`cond/1` special form][cond] to decide if an alert should be sent.
- You can use [equality operators][equality] to compare atoms for equality.

[equality]: https://elixir-lang.org/getting-started/basic-operators.html
[atom]: https://elixir-lang.org/getting-started/basic-types.html#atoms
[cond]: https://elixir-lang.org/getting-started/case-cond-and-if.html#cond
