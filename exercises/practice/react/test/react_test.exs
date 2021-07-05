defmodule ReactTest do
  use ExUnit.Case
  alias React.{InputCell, OutputCell}

  # @tag :pending
  test "input cells have a value" do
    {:ok, cells} = React.new([%InputCell{name: "input", value: 10}])
    assert React.get_value(cells, "input") == 10
  end

  @tag :pending
  test "an input cell's value can be set" do
    {:ok, cells} = React.new([%InputCell{name: "input", value: 4}])

    React.set_value(cells, "input", 20)
    assert React.get_value(cells, "input") == 20
  end

  @tag :pending
  test "compute cells calculate initial value" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    assert React.get_value(cells, "output") == 2
  end

  @tag :pending
  test "compute cells take inputs in the right order" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "one", value: 1},
        %InputCell{name: "two", value: 2},
        %OutputCell{name: "output", inputs: ["one", "two"], compute: fn a, b -> a + b * 10 end}
      ])

    assert React.get_value(cells, "output") == 21
  end

  @tag :pending
  test "compute cells update value when dependencies are changed" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    React.set_value(cells, "input", 3)
    assert React.get_value(cells, "output") == 4
  end

  @tag :pending
  test "compute cells can depend on other compute cells" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "times_two", inputs: ["input"], compute: fn a -> a * 2 end},
        %OutputCell{name: "times_thirty", inputs: ["input"], compute: fn a -> a * 30 end},
        %OutputCell{
          name: "output",
          inputs: ["times_two", "times_thirty"],
          compute: fn a, b -> a + b end
        }
      ])

    assert React.get_value(cells, "output") == 32
    React.set_value(cells, "input", 3)
    assert React.get_value(cells, "output") == 96
  end

  @tag :pending
  test "compute cells fire callbacks" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    React.add_callback(cells, "output", "callback1")
    callbacks = React.set_value(cells, "input", 3)
    assert callbacks["callback1"] == 4
  end

  @tag :pending
  test "callback cells only fire on change" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{
          name: "output",
          inputs: ["input"],
          compute: fn a -> if(a < 3, do: 111, else: 222) end
        }
      ])

    React.add_callback(cells, "output", "callback1")
    callbacks = React.set_value(cells, "input", 2)
    assert not Map.has_key?(callbacks, "callback1")
    callbacks = React.set_value(cells, "input", 4)
    assert callbacks["callback1"] == 222
  end

  @tag :pending
  test "callbacks do not report already reported values" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    React.add_callback(cells, "output", "callback1")
    callbacks = React.set_value(cells, "input", 2)
    assert callbacks["callback1"] == 3
    callbacks = React.set_value(cells, "input", 3)
    assert callbacks["callback1"] == 4
  end

  @tag :pending
  test "callbacks can fire from multiple cells" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "plus_one", inputs: ["input"], compute: fn a -> a + 1 end},
        %OutputCell{name: "minus_one", inputs: ["input"], compute: fn a -> a - 1 end}
      ])

    React.add_callback(cells, "plus_one", "callback1")
    React.add_callback(cells, "minus_one", "callback2")
    callbacks = React.set_value(cells, "input", 10)
    assert callbacks["callback1"] == 11
    assert callbacks["callback2"] == 9
  end

  @tag :pending
  test "callbacks can be added and removed" do
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 11},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    React.add_callback(cells, "output", "callback1")
    React.add_callback(cells, "output", "callback2")
    callbacks = React.set_value(cells, "input", 31)
    assert callbacks["callback1"] == 32
    assert callbacks["callback2"] == 32
    React.remove_callback(cells, "output", "callback1")
    React.add_callback(cells, "output", "callback3")
    callbacks = React.set_value(cells, "input", 41)
    assert not Map.has_key?(callbacks, "callback1")
    assert callbacks["callback2"] == 42
    assert callbacks["callback3"] == 42
  end

  @tag :pending
  test "removing a callback multiple times doesn't interfere with other callbacks" do
    # Some incorrect implementations store their callbacks in an array
    # and removing a callback repeatedly either removes an unrelated callback
    # or causes an out of bounds access.
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "output", inputs: ["input"], compute: fn a -> a + 1 end}
      ])

    React.add_callback(cells, "output", "callback1")
    React.add_callback(cells, "output", "callback2")
    React.remove_callback(cells, "output", "callback1")
    React.remove_callback(cells, "output", "callback1")
    React.remove_callback(cells, "output", "callback1")
    callbacks = React.set_value(cells, "input", 2)
    assert not Map.has_key?(callbacks, "callback1")
    assert callbacks["callback2"] == 3
  end

  @tag :pending
  test "callbacks should only be called once even if multiple dependencies change" do
    # Some incorrect implementations call a callback function too early,
    # when not all of the inputs of a compute cell have propagated new values.
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "plus_one", inputs: ["input"], compute: fn a -> a + 1 end},
        %OutputCell{name: "minus_one1", inputs: ["input"], compute: fn a -> a - 1 end},
        %OutputCell{name: "minus_one2", inputs: ["minus_one1"], compute: fn a -> a - 1 end},
        %OutputCell{
          name: "output",
          inputs: ["plus_one", "minus_one2"],
          compute: fn a, b -> a * b end
        }
      ])

    React.add_callback(cells, "output", "callback1")
    callbacks = React.set_value(cells, "input", 4)
    assert callbacks["callback1"] == 10
  end

  @tag :pending
  test "callbacks should not be called if dependencies change but output value doesn't change" do
    # Some incorrect implementations simply mark a compute cell as dirty when a dependency changes,
    # then call callbacks on all dirty cells.
    # This is incorrect since the specification indicates only to call callbacks on change.
    {:ok, cells} =
      React.new([
        %InputCell{name: "input", value: 1},
        %OutputCell{name: "plus_one", inputs: ["input"], compute: fn a -> a + 1 end},
        %OutputCell{name: "minus_one", inputs: ["input"], compute: fn a -> a - 1 end},
        %OutputCell{
          name: "always_two",
          inputs: ["plus_one", "minus_one"],
          compute: fn a, b -> a - b end
        }
      ])

    React.add_callback(cells, "always_two", "callback1")
    callbacks = React.set_value(cells, "input", 2)
    assert not Map.has_key?(callbacks, "callback1")
    callbacks = React.set_value(cells, "input", 3)
    assert not Map.has_key?(callbacks, "callback1")
    callbacks = React.set_value(cells, "input", 4)
    assert not Map.has_key?(callbacks, "callback1")
    callbacks = React.set_value(cells, "input", 5)
    assert not Map.has_key?(callbacks, "callback1")
  end
end
