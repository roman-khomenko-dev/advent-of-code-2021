defmodule AdventOfCode2021.Dive do
  @moduledoc """
  Advent of Code 2021
  Day 2: Dive!
  """
  @data %{depth: 0, horizontal: 0, aim: 0}

  @spec figure_out(1 | 2) :: {:ok, number}
  def figure_out(type) when type in [1, 2] do
    {_, puzzle} = get_puzzle()

    course =
      Enum.reduce(puzzle, @data, fn move, acc ->
        proceed_move(type, acc, move)
      end)

    {:ok, course.horizontal * course.depth}
  end

  defp proceed_move(_type = 1, data, _move = %{action: action, value: value}) do
    case action do
      "up" -> %{data | depth: data.depth - value}
      "down" -> %{data | depth: data.depth + value}
      "forward" -> %{data | horizontal: data.horizontal + value}
    end
  end

  defp proceed_move(_type = 2, data, _move = %{action: action, value: value}) do
    case action do
      "up" -> %{data | aim: data.aim - value}
      "down" -> %{data | aim: data.aim + value}
      "forward" -> %{data | horizontal: data.horizontal + value, depth: data.aim * value + data.depth}
    end
  end

  defp proceed_move(_type, _data, _move) do
    {:error, "Wrong parameters"}
  end

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_2/puzzle_input.txt") do
      array_puzzle =
        content
        |> String.split("\n", trim: true)
        |> Enum.map(fn line -> String.split(line, " ") end)

      mapped_puzzle =
        for [action, value] <- array_puzzle, do: %{action: action, value: String.to_integer(value)}

      {:ok, mapped_puzzle}
    end
  end
end
