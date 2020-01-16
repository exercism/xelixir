defmodule ExercismElixir.CaseHelper do
  @moduledoc """
  Converts strings between lowerCamelCase, UpperCamelCase, snake_case, and kebab-case.
  """

  @doc """
  Convert lowerCamelCase to UpperCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.lower_camel_to_upper_camel_case("fooBarBaz")
      "FooBarBaz"
  """
  def lower_camel_to_upper_camel_case(str) do
    str |> upcase_first_grapheme()
  end

  @doc """
  Convert lowerCamelCase to snake_case

  ## Examples

      iex> ExercismElixir.CaseHelper.lower_camel_to_snake_case("fooBarBaz")
      "foo_bar_baz"
  """
  def lower_camel_to_snake_case(str) do
    str |> String.replace(~r/[[:upper:]]/u, fn char -> "_" <> String.downcase(char) end)
  end

  @doc """
  Convert lowerCamelCase to kebab-case

  ## Examples

      iex> ExercismElixir.CaseHelper.lower_camel_to_kebab_case("fooBarBaz")
      "foo-bar-baz"
  """
  def lower_camel_to_kebab_case(str) do
    str |> String.replace(~r/[[:upper:]]/u, fn char -> "-" <> String.downcase(char) end)
  end

  @doc """
  Convert UpperCamelCase to lowerCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.upper_camel_to_lower_camel_case("FooBarBaz")
      "fooBarBaz"
  """
  def upper_camel_to_lower_camel_case(str) do
    str |> downcase_first_grapheme()
  end

  @doc """
  Convert UpperCamelCase to snake_case

  ## Examples

      iex> ExercismElixir.CaseHelper.upper_camel_to_snake_case("FooBarBaz")
      "foo_bar_baz"
  """
  def upper_camel_to_snake_case(str) do
    str |> upper_camel_to_lower_camel_case() |> lower_camel_to_snake_case()
  end

  @doc """
  Convert UpperCamelCase to kebab-case

  ## Examples

      iex> ExercismElixir.CaseHelper.upper_camel_to_kebab_case("FooBarBaz")
      "foo-bar-baz"
  """
  def upper_camel_to_kebab_case(str) do
    str |> upper_camel_to_lower_camel_case() |> lower_camel_to_kebab_case()
  end

  @doc """
  Convert snake_case to lowerCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.snake_to_lower_camel_case("foo_bar_baz")
      "fooBarBaz"
  """
  def snake_to_lower_camel_case(str) do
    str |> String.replace(~r/_[[:alpha:]]/u, fn "_" <> char -> String.upcase(char) end)
  end

  @doc """
  Convert snake_case to UpperCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.snake_to_upper_camel_case("foo_bar_baz")
      "FooBarBaz"
  """
  def snake_to_upper_camel_case(str) do
    str |> snake_to_lower_camel_case() |> upcase_first_grapheme()
  end

  @doc """
  Convert snake_case to kebab-case

  ## Examples

      iex> ExercismElixir.CaseHelper.snake_to_kebab_case("foo_bar_baz")
      "foo-bar-baz"
  """
  def snake_to_kebab_case(str) do
    str |> String.replace("_", "-")
  end

  @doc """
  Convert kebab-case to lowerCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.kebab_to_lower_camel_case("foo-bar-baz")
      "fooBarBaz"
  """
  def kebab_to_lower_camel_case(str) do
    str |> String.replace(~r/-[[:alpha:]]/u, fn "-" <> char -> String.upcase(char) end)
  end

  @doc """
  Convert kebab-case to UpperCamelCase

  ## Examples

      iex> ExercismElixir.CaseHelper.kebab_to_upper_camel_case("foo-bar-baz")
      "FooBarBaz"
  """
  def kebab_to_upper_camel_case(str) do
    str |> kebab_to_lower_camel_case() |> upcase_first_grapheme()
  end

  @doc """
  Convert kebab-case to snake_case

  ## Examples

      iex> ExercismElixir.CaseHelper.kebab_to_snake_case("foo-bar-baz")
      "foo_bar_baz"
  """
  def kebab_to_snake_case(str) do
    str |> String.replace("-", "_")
  end

  defp downcase_first_grapheme(str) do
    case String.next_grapheme(str) do
      {first, rest} -> String.downcase(first) <> rest
      nil -> ""
    end
  end

  defp upcase_first_grapheme(str) do
    case String.next_grapheme(str) do
      {first, rest} -> String.upcase(first) <> rest
      nil -> ""
    end
  end
end
