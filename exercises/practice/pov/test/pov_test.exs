defmodule PovTest do
  use ExUnit.Case

  def equal_trees({a, children_a}, {a, children_b}) do
    if length(children_a) == length(children_b) do
      sorted_a = Enum.sort(children_a)
      sorted_b = Enum.sort(children_b)

      Enum.zip_with(sorted_a, sorted_b, &equal_trees/2)
      |> Enum.all?()
    else
      false
    end
  end

  def equal_trees(_a, _b), do: false

  def leaf(a), do: {a, []}

  describe "Reroot a tree so that its root is the specified node." do
    # @tag :pending
    test "Results in the same tree if the input tree is a singleton" do
      t = leaf(:x)
      assert equal_trees(t, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Can reroot a tree with a parent and one sibling" do
      t = {:parent, [leaf(:x), leaf(:sibling)]}
      t_final = {:x, [{:parent, [leaf(:sibling)]}]}

      assert equal_trees(t_final, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Can reroot a tree with a parent and many siblings" do
      t = {:parent, [leaf(:a), leaf(:x), leaf(:b), leaf(:c)]}
      t_final = {:x, [{:parent, [leaf(:a), leaf(:b), leaf(:c)]}]}

      assert equal_trees(t_final, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Can reroot a tree with new root deeply nested in tree" do
      t = {:level0, [{:level1, [{:level2, [{:level3, [leaf(:x)]}]}]}]}
      t_final = {:x, [{:level3, [{:level2, [{:level1, [leaf(:level0)]}]}]}]}
      assert equal_trees(t_final, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Moves children of the new root to same level as former parent" do
      t = {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}]}
      t_final = {:x, [leaf(:kid0), leaf(:kid1), leaf(:parent)]}
      assert equal_trees(t_final, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Can reroot a complex tree with cousins" do
      t =
        {:grandparent,
         [
           {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}, leaf(:sibling0), leaf(:sibling1)]},
           {:uncle, [leaf(:cousin0), leaf(:cousin1)]}
         ]}

      t_final =
        {:x,
         [
           leaf(:kid0),
           leaf(:kid1),
           {:parent,
            [
              leaf(:sibling0),
              leaf(:sibling1),
              {:grandparent, [{:uncle, [leaf(:cousin0), leaf(:cousin1)]}]}
            ]}
         ]}

      assert equal_trees(t_final, Pov.from_pov(t, :x))
    end

    @tag :pending
    test "Errors if target does not exist in a singleton tree" do
      t = {:x, []}
      error = {:error, :nonexistent_target}
      assert Pov.from_pov(t, :nonexistent) == error
    end

    @tag :pending
    test "Errors if target does not exist in a large tree" do
      t = {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}, leaf(:sib1), leaf(:sib2)]}
      error = {:error, :nonexistent_target}
      assert Pov.from_pov(t, :nonexistent) == error
    end
  end

  describe "Given two nodes, find the path between them" do
    @tag :pending
    test "Can find path to parent" do
      t = {:parent, [leaf(:x), leaf(:sibling)]}
      assert Pov.path_between(t, :x, :parent) == [:x, :parent]
    end

    @tag :pending
    test "Can find path to sibling" do
      t = {:parent, [leaf(:a), leaf(:x), leaf(:b), leaf(:c)]}
      assert Pov.path_between(t, :x, :b) == [:x, :parent, :b]
    end

    @tag :pending
    test "Can find path to cousin" do
      t =
        {:grandparent,
         [
           {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}, leaf(:sib1), leaf(:sib2)]},
           {:uncle, [leaf(:cousin1), leaf(:cousin2)]}
         ]}

      assert Pov.path_between(t, :x, :cousin1) == [:x, :parent, :grandparent, :uncle, :cousin1]
    end

    @tag :pending
    test "Can find path not involving root" do
      t = {:grandparent, [{:parent, [leaf(:x), leaf(:sib1), leaf(:sib2)]}]}
      assert Pov.path_between(t, :x, :sib1) == [:x, :parent, :sib1]
    end

    @tag :pending
    test "Can find path from nodes other than x" do
      t = {:parent, [leaf(:a), leaf(:x), leaf(:b), leaf(:c)]}
      assert Pov.path_between(t, :a, :c) == [:a, :parent, :c]
    end

    @tag :pending
    test "Errors if destination does not exist" do
      t = {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}, leaf(:sib1), leaf(:sib2)]}
      error = {:error, :nonexistent_destination}
      assert Pov.path_between(t, :x, :nonexistent) == error
    end

    @tag :pending
    test "Errors if source does not exist" do
      t = {:parent, [{:x, [leaf(:kid0), leaf(:kid1)]}, leaf(:sib1), leaf(:sib2)]}
      error = {:error, :nonexistent_source}
      assert Pov.path_between(t, :nonexistent, :x) == error
    end
  end
end
