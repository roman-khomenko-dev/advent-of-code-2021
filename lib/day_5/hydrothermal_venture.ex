defmodule AdventOfCode2021.HydrothermalVenture do
  @moduledoc """
  Advent of Code 2021
  Day 5: Hydrothermal Venture
  """

  def venture_forward_overlap do
    get_puzzle()
    |> define_grid_points(:forward)
    |> calculate_overlap()
  end

  def venture_diagonal_overlap do
    get_puzzle()
    |> define_grid_points(:diagonal)
    |> calculate_overlap()
  end

  defp define_grid_points(data, type) do
    Enum.reduce(data, %{}, fn
      [x1, y, x2, y], grid ->
        find_line_point({x1, x2, y}, grid, :horizontal)

      [x, y1, x, y2], grid ->
        find_line_point({y1, y2, x}, grid, :vertical)

      [x1, y1, x2, y2], grid ->
        find_diagonal_point({x1, x2, y1, y2}, grid, type)
    end)
  end

  defp find_diagonal_point({x1, x2, y1, y2}, grid, :diagonal) do
    [x1..x2, y1..y2]
    |> Enum.zip()
    |> Enum.reduce(grid, fn point, grid ->
      Map.update(grid, point, 1, &(&1 + 1))
    end)
  end

  defp find_diagonal_point(_data, grid, _type), do: grid

  defp find_line_point({n1, n2, state_value}, line, axis) do
    Enum.reduce(n1..n2, line, fn n, line ->
      Map.update(line, change_point_rule({n, state_value, axis}), 1, &(&1 + 1))
    end)
  end

  defp change_point_rule({n, state_value, axis}),
    do: if(axis == :horizontal, do: {n, state_value}, else: {state_value, n})

  defp calculate_overlap(grid), do: Enum.count(grid, fn {_k, value} -> value > 1 end)

  defp get_puzzle do
    {:ok, content} = File.read("lib/day_5/puzzle_input.txt")

    content
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split([",", " -> "])
      |> Enum.map(&String.to_integer(&1))
    end)
  end
end
