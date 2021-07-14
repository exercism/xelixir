# Hints

## General

- In Elixir's ['Getting Started Guide'][guide] there is a nice refresher about named functions.

## 1. Make the response when the guess matches the secret number

- You can use a [guard][guard] to check if the numbers are the same with `===/2`.

## 2. Make the response when the guess is greater than the secret number

- You can add a [function clause][multiple-fn-clauses] and [guards][guard] to check if the guess is greater `>/2` than the secret number.

## 3. Make the response when the guess is less than the secret number

- You can add a [function clause][multiple-fn-clauses] and [guards][guard] to check if the guess is less than `</2` the secret number.

## 4. Make the responses when the guess is one more or one less than the secret number

- You can add a [function clause][multiple-fn-clauses] and [guards][guard] to check if the guess is one less or one more than the secret number.
- Guards expressions can use `and/2`, or `or/2` to combine boolean expressions.
- Pay attention to the order of the function clauses.

## 5. Make the response when there is no guess

- You can make use of a [default argument][default-arg] for a guess. The default value does not have to be an integer.
- Use a function header before all the other function clauses to define the default argument.

[default-arg]: https://elixir-lang.org/getting-started/modules-and-functions.html#default-arguments
[guard]: https://hexdocs.pm/elixir/master/Kernel.html#guards
[guide]: https://elixir-lang.org/getting-started/modules-and-functions.html#named-functions
[multiple-fn-clauses]: https://elixir-lang.org/getting-started/modules-and-functions.html#named-functions
