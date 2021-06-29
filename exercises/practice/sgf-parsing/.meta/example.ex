defmodule SgfParsing do
  # Used to make recursive parsers lazy
  defmacro lazy(parser) do
    quote do
      fn string -> unquote(parser).(string) end
    end
  end

  defmodule Sgf do
    defstruct properties: %{}, children: []
  end

  @type sgf :: %Sgf{properties: map, children: [sgf]}
  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) do
    parser = parse_tree_paren() |> eof()

    with {:ok, tree, ""} <- run_parser(parser, encoded) do
      {:ok, tree}
    else
      {:error, err, _rest} -> {:error, err}
    end
  end

  # TREE PARSER

  def parse_tree() do
    lift2(
      &%Sgf{properties: &1, children: &2},
      char(?;)
      |> error("tree with no nodes")
      |> drop_and(many(parse_property()))
      |> map(&Map.new/1),
      lazy(
        one_of([
          map(parse_tree(), &List.wrap/1),
          many(parse_tree_paren())
        ])
      )
    )
  end

  def parse_tree_paren() do
    char(?()
    |> error("tree missing")
    |> drop_and(parse_tree())
    |> drop(char(?)))
  end

  def parse_property() do
    lift2(
      &{&1, &2},
      some(satisfy(&(&1 not in '[();')))
      |> map(&Enum.join(&1, ""))
      |> validate(&(&1 == String.upcase(&1)), "property must be in uppercase"),
      some(
        char(?[)
        |> error("properties without delimiter")
        |> drop_and(many(escaped(&(&1 != ?]))))
        |> drop(char(?]))
        |> map(&Enum.join(&1, ""))
      )
    )
  end

  def escaped(p) do
    one_of([
      lift2(&escape/2, char(?\\), satisfy(&(&1 in 'nt]['))),
      satisfy(p)
    ])
  end

  def escape("\\", "n"), do: "\n"
  def escape("\\", "t"), do: "\t"
  def escape("\\", "]"), do: "]"
  def escape("\\", "["), do: "["

  # PARSER COMBINATORS LIBRARY
  # Inspired from Haskell libraries like Parsec
  # and https://serokell.io/blog/parser-combinators-in-elixir

  def run_parser(parser, string), do: parser.(string)

  def eof(parser) do
    fn string ->
      with {:ok, _, ""} = ok <- parser.(string) do
        ok
      else
        {:ok, _a, rest} -> {:error, "Not end of file", rest}
        err -> err
      end
    end
  end

  def satisfy(p) do
    fn
      <<char, rest::bitstring>> = string ->
        if p.(char) do
          {:ok, <<char>>, rest}
        else
          {:error, "unexpected #{char}", string}
        end

      "" ->
        {:error, "unexpected end of string", ""}
    end
  end

  def char(c), do: satisfy(&(&1 == c)) |> error("expected character #{<<c>>}")

  def string(str) do
    str
    |> to_charlist
    |> Enum.map(&char/1)
    |> Enum.reduce(inject(""), &lift2(fn a, b -> a <> b end, &1, &2))
  end

  def some(parser) do
    fn input ->
      with {:ok, result, rest} <- parser.(input),
           {:ok, results, rest} <- many(parser).(rest) do
        {:ok, [result | results], rest}
      end
    end
  end

  def many(parser) do
    fn input ->
      with {:ok, result, rest} <- some(parser).(input) do
        {:ok, result, rest}
      else
        {:error, _err, ^input} -> {:ok, [], input}
        err -> err
      end
    end
  end

  def one_of(parsers) when is_list(parsers) do
    fn string ->
      Enum.reduce_while(parsers, {:error, "no parsers", string}, fn
        _parser, {:ok, _, _} = result -> {:halt, result}
        parser, _err -> {:cont, parser.(string)}
      end)
    end
  end

  def map(parser, f) do
    fn string ->
      with {:ok, a, rest} <- parser.(string) do
        {:ok, f.(a), rest}
      end
    end
  end

  def error(parser, err) do
    fn string ->
      with {:error, _err, rest} <- parser.(string) do
        {:error, err, rest}
      end
    end
  end

  def drop(p1, p2) do
    fn string ->
      with {:ok, a, rest} <- p1.(string),
           {:ok, _, rest} <- p2.(rest) do
        {:ok, a, rest}
      end
    end
  end

  def drop_and(p1, p2) do
    fn string ->
      with {:ok, _, rest} <- p1.(string) do
        p2.(rest)
      end
    end
  end

  def inject(a) do
    fn string -> {:ok, a, string} end
  end

  def lift2(pair, p1, p2) do
    fn string ->
      with {:ok, a, rest} <- p1.(string),
           {:ok, b, rest} <- p2.(rest) do
        {:ok, pair.(a, b), rest}
      end
    end
  end

  def validate(parser, p, err) do
    fn string ->
      with {:ok, result, rest} <- parser.(string) do
        if p.(result) do
          {:ok, result, rest}
        else
          {:error, err, rest}
        end
      end
    end
  end
end