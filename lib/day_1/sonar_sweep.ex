defmodule AdventOfCode2021.SonarSweep do
  @moduledoc """
  Advent of Code 2021
  Day 1: Sonar Sweep
  """

  def find_keys(type = 1) do
    {_, puzzle} = get_puzzle()
    data = %{keys: 0, previous: nil}

    result = Enum.reduce(puzzle, data, fn value, acc ->
      proceed_key(1, acc, value)
    end)
    inspect(result.keys)
  end

  def find_keys(type = 2) do
    {_, puzzle} = get_puzzle()
    data = %{keys: 0, previous: nil}
    chunked_puzzle = Enum.chunk_every(puzzle, 3, 1, :discard)

    result = Enum.reduce(chunked_puzzle, data, fn value, acc ->
      proceed_key(2, acc, value)
    end)
    inspect(result.keys)
  end

  defp proceed_key(type = 1, data, value) do
    if value > data.previous, do: %{data | keys: data.keys + 1, previous: value}, else: %{data | previous: value}
  end

  defp proceed_key(type = 2, data = %{previous: nil}, value) do
    %{data | previous: value}
  end

  defp proceed_key(type = 2, data, value) do
    if Enum.sum(value) > Enum.sum(data.previous), do: %{data | keys: data.keys + 1, previous: value}, else: %{data | previous: value}
  end

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_1/puzzle_input.txt") do
      {:ok, content
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)}
    end
  end
end
