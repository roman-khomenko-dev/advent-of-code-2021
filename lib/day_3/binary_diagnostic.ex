defmodule AdventOfCode2021.BinaryDiagnostic do
  @moduledoc """
  Advent of Code 2021
  Day 3: Binary Diagnostic
  """

  @spec power_consumption :: number
  def power_consumption do
    {_, puzzle} = get_puzzle()
    data = %{gamma_rate: "", epsilon_rate: ""}

    width =
      puzzle
      |> List.first()
      |> String.length()

    0..(width - 1)
    |> Enum.map(&get_index_diff(puzzle, &1))
    |> Enum.reduce(data, fn row, acc ->
      %{
        acc
        | gamma_rate: acc.gamma_rate <> common_bit(row),
          epsilon_rate: acc.epsilon_rate <> less_bit(row)
      }
    end)
    |> Enum.into([], fn {_key, value} -> get_decimal(value) end)
    |> Enum.product()
  end

  @spec life_support_rating :: integer
  def life_support_rating do
    data = %{puzzle: elem(get_puzzle(), 1)}

    width =
      data.puzzle
      |> List.first()
      |> String.length()

    with oxygen <- get_rating_value(width, {data, "common"}),
         scrubber <- get_rating_value(width, {%{puzzle: elem(get_puzzle(), 1)}, "less"}) do
      oxygen * scrubber
    end
  end

  defp get_rating_value(width, {data, type}) when type in ["common", "less"] do
    0..(width - 1)
    |> Enum.reduce_while(data, fn index, acc ->
      common =
        acc.puzzle
        |> get_index_diff(index)
        |> rating_bit(type)

      acc = %{
        acc
        | puzzle: Enum.filter(acc.puzzle, fn row -> String.at(row, index) == common end)
      }

      if length(acc.puzzle) > 1, do: {:cont, acc}, else: {:halt, acc}
    end)
    |> Map.get(:puzzle)
    |> List.first()
    |> get_decimal()
  end

  defp rating_bit(value, "common" = _type), do: common_bit(value)

  defp rating_bit(value, "less" = _type), do: less_bit(value)

  defp get_index_diff(puzzle, index) do
    %{
      index: index,
      zero: get_index_count(puzzle, index, "0"),
      one: get_index_count(puzzle, index, "1")
    }
  end

  defp get_decimal(number) when is_binary(number), do: elem(Integer.parse(number, 2), 0)

  defp get_index_count(puzzle, index, bit), do: Enum.count(puzzle, &(String.at(&1, index) == bit))

  defp common_bit(%{one: one, zero: zero} = _row), do: if(one >= zero, do: "1", else: "0")

  defp less_bit(%{one: one, zero: zero} = _row), do: if(zero <= one, do: "0", else: "1")

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_3/puzzle_input.txt") do
      {:ok, String.split(content, "\n", trim: true)}
    end
  end
end
