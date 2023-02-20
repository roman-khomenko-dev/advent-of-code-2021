defmodule AdventOfCode2021.BinaryDiagnostic do
  @moduledoc """
  Advent of Code 2021
  Day 3: Binary Diagnostic
  """

  @spec power_consumption :: number
  def power_consumption do
    {_, puzzle} = get_puzzle()
    data = %{gamma_rate: "", epsilon_rate: ""}
    # Get map with index and count values to compare
    puzzle
    |> puzzle_symbol_range()
    |> Enum.map(&bit_count(puzzle, &1))
    # Compose gamma and epsilon strings
    |> compose_characteristics(data)
    # Put values to list and calculate multiply result
    |> calculate_result()
  end

  @spec life_support_rating :: integer
  def life_support_rating do
    data = %{puzzle: elem(get_puzzle(), 1)}

    with oxygen <- get_rating_value(data.puzzle, {data, :common}),
         scrubber <- get_rating_value(data.puzzle, {%{puzzle: elem(get_puzzle(), 1)}, :less}) do
      oxygen * scrubber
    end
  end

  defp get_rating_value(puzzle, {data, type}) when type in [:common, :less] do
    puzzle
    |> puzzle_symbol_range()
    # Find dominant or least bit at row index
    |> Enum.reduce_while(data, fn index, acc ->
      bit =
        acc.puzzle
        |> bit_count(index)
        |> rating_bit(type)
    # Filter data to keep bitstring only with a properly bit at index
      acc = %{
        acc
        | puzzle: Enum.filter(acc.puzzle, fn row -> String.at(row, index) == bit end)
      }

      if length(acc.puzzle) > 1, do: {:cont, acc}, else: {:halt, acc}
    end)
    # Get value from map, parse to decimal
    |> Map.get(:puzzle)
    |> List.first()
    |> get_decimal()
  end

  defp calculate_result(data) do
    data
    |> Enum.into([], fn {_key, value} -> get_decimal(value) end)
    |> Enum.product()
  end

  defp compose_characteristics(bit_map, data) do
    Enum.reduce(bit_map, data, fn row, acc ->
      %{
        acc
        | gamma_rate: acc.gamma_rate <> dominant_bit_value(row),
          epsilon_rate: acc.epsilon_rate <> least_bit_value(row)
      }
    end)
  end

  defp rating_bit(value, :common = _type), do: dominant_bit_value(value)

  defp rating_bit(value, :less = _type), do: least_bit_value(value)

  defp bit_count(puzzle, index) do
    %{
      zero: get_index_count(puzzle, index, "0"),
      one: get_index_count(puzzle, index, "1")
    }
  end

  defp get_decimal(number) when is_binary(number) do
    number
    |> Integer.parse(2)
    |> elem(0)
  end

  defp get_index_count(puzzle, index, bit), do: Enum.count(puzzle, &(String.at(&1, index) == bit))

  defp dominant_bit_value(%{one: one, zero: zero} = _row), do: if(one >= zero, do: "1", else: "0")

  defp least_bit_value(%{one: one, zero: zero} = _row), do: if(zero <= one, do: "0", else: "1")

  defp puzzle_symbol_range(puzzle) do
    length =
      puzzle
      |> List.first()
      |> String.length()

    0..(length - 1)
  end

  defp get_puzzle do
    with {:ok, content} <- File.read("lib/day_3/puzzle_input.txt") do
      {:ok, String.split(content, "\n", trim: true)}
    end
  end
end
