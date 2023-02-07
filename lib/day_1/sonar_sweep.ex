defmodule AdventOfCode2021.SonarSweep do
  @moduledoc """
  Advent of Code 2021
  Day 1: Sonar Sweep
  """

  @puzzle_input []

  def find_keys do
    {_, puzzle} = get_puzzle()
    data = %{keys:  0, previous: nil}

    result = Enum.reduce(puzzle, data, fn value, acc ->
      proceed_key(acc, value)
    end)
    inspect(result.keys)
  end

  defp proceed_key(data, value) do
    if value > data.previous, do: %{data | keys: data.keys + 1, previous: value}, else: %{data | previous: value}
  end

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_1/puzzle_input.txt") do
      {:ok, content
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)}
    end
  end
end
