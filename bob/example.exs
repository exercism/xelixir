defmodule Teenager do
  @doc """
  Answers to `hey` like a teenager.

  ## Examples

  iex> Teenager.hey("")
  "Fine. Be that way!"

  iex> Teenager.hey("Do you like math?")
  "Sure."

  iex> Teenager.hey("HELLO!")
  "Whoa, chill out!"

  iex> Teenager.hey("Coding is cool.")
  "Whatever."
  """

  def hey(input) do
    cond do
      silent?(input)   -> "Fine. Be that way!"
      shouting?(input) -> "Whoa, chill out!"
      question?(input) -> "Sure."
      true             -> "Whatever."
    end
  end

  defp silent?(input),   do: "" == String.strip(input)
  defp shouting?(input), do: input == String.upcase(input) && letters?(input)
  defp question?(input), do: String.ends_with?(input, "?")
  defp letters?(input),  do: Regex.match?(~r/\p{L}+/, input)
end

# Another approach which abstracts knowing about string categories 
# away from Teenager and into a single responsibility module.
# (This has been commented out to avoid raising a needless "redefinition"
# warning)

# defmodule Message do
#   def silent?(input),   do: "" == String.strip(input)
#   def shouting?(input), do: input == String.upcase(input) && letters?(input)
#   def question?(input), do: String.ends_with?(input, "?")
#   defp letters?(input), do: Regex.match?(~r/\p{L}+/, input)
# end
# 
# defmodule Teenager do
#   import Message, only: [silent?: 1, shouting?: 1, question?: 1]
# 
#   def hey(input) do
#     cond do
#       silent?(input)   -> "Fine. Be that way!"
#       shouting?(input) -> "Whoa, chill out!"
#       question?(input) -> "Sure."
#       true             -> "Whatever."
#     end
#   end
# end
