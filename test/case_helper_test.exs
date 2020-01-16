defmodule ExercismElixir.CaseHelperTest do
  use ExUnit.Case
  alias ExercismElixir.CaseHelper
  doctest CaseHelper

  test "converts cases properly" do
    assert CaseHelper.lower_camel_to_upper_camel_case("fooBarBaz") == "FooBarBaz"
    assert CaseHelper.lower_camel_to_snake_case("fooBarBaz") == "foo_bar_baz"
    assert CaseHelper.lower_camel_to_kebab_case("fooBarBaz") == "foo-bar-baz"
    assert CaseHelper.upper_camel_to_lower_camel_case("FooBarBaz") == "fooBarBaz"
    assert CaseHelper.upper_camel_to_snake_case("FooBarBaz") == "foo_bar_baz"
    assert CaseHelper.upper_camel_to_kebab_case("FooBarBaz") == "foo-bar-baz"
    assert CaseHelper.snake_to_lower_camel_case("foo_bar_baz") == "fooBarBaz"
    assert CaseHelper.snake_to_upper_camel_case("foo_bar_baz") == "FooBarBaz"
    assert CaseHelper.snake_to_kebab_case("foo_bar_baz") == "foo-bar-baz"
    assert CaseHelper.kebab_to_lower_camel_case("foo-bar-baz") == "fooBarBaz"
    assert CaseHelper.kebab_to_upper_camel_case("foo-bar-baz") == "FooBarBaz"
    assert CaseHelper.kebab_to_snake_case("foo-bar-baz") == "foo_bar_baz"
  end

  test "handles non-ascii characters" do
    assert CaseHelper.lower_camel_to_upper_camel_case("приветМир") == "ПриветМир"
    assert CaseHelper.lower_camel_to_snake_case("приветМир") == "привет_мир"
    assert CaseHelper.lower_camel_to_kebab_case("приветМир") == "привет-мир"
    assert CaseHelper.upper_camel_to_lower_camel_case("ПриветМир") == "приветМир"
    assert CaseHelper.upper_camel_to_snake_case("ПриветМир") == "привет_мир"
    assert CaseHelper.upper_camel_to_kebab_case("ПриветМир") == "привет-мир"
    assert CaseHelper.snake_to_lower_camel_case("привет_мир") == "приветМир"
    assert CaseHelper.snake_to_upper_camel_case("привет_мир") == "ПриветМир"
    assert CaseHelper.snake_to_kebab_case("привет_мир") == "привет-мир"
    assert CaseHelper.kebab_to_lower_camel_case("привет-мир") == "приветМир"
    assert CaseHelper.kebab_to_upper_camel_case("привет-мир") == "ПриветМир"
    assert CaseHelper.kebab_to_snake_case("привет-мир") == "привет_мир"
  end

  test "does not error on empty strings" do
    assert CaseHelper.lower_camel_to_upper_camel_case("") == ""
    assert CaseHelper.lower_camel_to_snake_case("") == ""
    assert CaseHelper.lower_camel_to_kebab_case("") == ""
    assert CaseHelper.upper_camel_to_lower_camel_case("") == ""
    assert CaseHelper.upper_camel_to_snake_case("") == ""
    assert CaseHelper.upper_camel_to_kebab_case("") == ""
    assert CaseHelper.snake_to_lower_camel_case("") == ""
    assert CaseHelper.snake_to_upper_camel_case("") == ""
    assert CaseHelper.snake_to_kebab_case("") == ""
    assert CaseHelper.kebab_to_lower_camel_case("") == ""
    assert CaseHelper.kebab_to_upper_camel_case("") == ""
    assert CaseHelper.kebab_to_snake_case("") == ""
  end
end
