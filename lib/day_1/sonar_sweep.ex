defmodule AdventOfCode2021.SonarSweep do
  @moduledoc """
  Advent of Code 2021
  Day 1: Sonar Sweep
  """

  @spec find_keys(1 | 2) :: non_neg_integer | {:error, atom}
  def find_keys(_type = 1) do
    with {:ok, puzzle} <- get_puzzle() do
      puzzle
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.count(fn [left, right] -> right > left end)
    end
  end

  def find_keys(_type = 2) do
    with {:ok, puzzle} <- get_puzzle() do
      puzzle
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.count(fn [left, right] -> Enum.sum(right) > Enum.sum(left) end)
    end
  end

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_1/puzzle_input.txt") do
      {:ok, content
            |> String.split("\n", trim: true)
            |> Enum.map(&String.to_integer/1)}
    end
  end
end
