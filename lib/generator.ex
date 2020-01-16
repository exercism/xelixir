defmodule ExercismElixir.Generator do
  alias ExercismElixir.CaseHelper

  def canonical_data(exercise_name) do
    "../exercism-problem-specifications/exercises/$EXERCISE_NAME/canonical-data.json"
    |> String.replace("$EXERCISE_NAME", exercise_name)
    |> File.read!()
    |> Jason.decode!()
  end

  def exercise_to_module(name) do
    CaseHelper.kebab_to_upper_camel_case(name)
  end

  def exercise_to_test_module(name) do
    exercise_to_module(name) <> "Test"
  end

  def exercise_to_test_file(name) do
    CaseHelper.kebab_to_snake_case(name) <> "_test.exs"
  end

  def test_file_contents(data) do
    module = data |> Map.fetch!("exercise") |> exercise_to_test_module()
    version = data |> Map.fetch!("version")

    ~s"""
    defmodule #{module} do
      # canonical data version #{version}
      use ExUnit.Case
    end
    """
  end

  def write(contents, file_path) do
    File.write!(file_path, contents)
  end
end
