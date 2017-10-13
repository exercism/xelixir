defmodule Transpose do
  @moduledoc """
  Documentation for Transpose.
  """

  def transpose(matrix) do
    rows = String.split(matrix, "\n")
    max_length = get_longest_row_length(rows)

    rows
    |> Enum.map(fn x -> get_padded_row(x, max_length) end)
    |> Enum.map(fn x -> String.to_charlist(x) end)
    |> List.zip
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> Enum.map(fn x -> List.to_string(x) end)
    |> Enum.map(fn x -> String.trim_trailing(x) end)
    |> Enum.join("\n")
  end

  defp get_longest_row_length(rows) do
    rows
    |> Enum.map(fn row -> String.length(row) end)
    |> Enum.max
  end

  defp get_padded_row(row, max_length) do
    padding = String.duplicate(" ", max_length - String.length(row)) 
    row <> padding
  end
end
