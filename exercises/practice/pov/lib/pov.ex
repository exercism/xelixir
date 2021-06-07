defmodule Pov do
  @typedoc """
  A tree, which is made of a node with several branches
  """
  @type tree :: {any, [tree]}

  @doc """
  Reparent a tree on a selected node.
  """
  @spec from_pov(tree :: tree, node :: any) :: tree | {:error, atom}
  def from_pov(tree, node) do
    # Implement this function
  end

  @doc """
  Finds a path between two nodes
  """
  @spec path_between(tree :: tree, from :: any, to :: any) :: [any] | {:error, atom}
  def path_between(tree, from, to) do
    # Implement this function
  end
end
