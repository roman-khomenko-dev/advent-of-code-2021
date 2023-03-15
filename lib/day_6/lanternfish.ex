defmodule AdventOfCode2021.Lanternfish do
  @moduledoc """
  Advent of Code 2021
  Day 6: Lanternfish
  """

  def lanternfish_growing(start_fish_quantity \\ 80) do
    fishes = get_puzzle()

    1..start_fish_quantity
    |> produce_fishes_grows(fishes)
    |> Enum.count()
  end

  def lanternfish_unlimited_growing(start_fish_quantity \\ 256) do
    growing_data =
      get_puzzle()
      |> Enum.frequencies()
      |> growing_schedule()

    {1..start_fish_quantity, growing_data}
    |> calendar_growth_result()
    |> comsume_schedule_result()
  end

  defp calendar_growth_result({days, growing_data}),
    do: Enum.reduce(days, growing_data, fn _day, acc -> proceed_growing(acc) end)

  defp proceed_growing(growing_schedule) do
    %{
      growing_schedule
      | "day_0" => Map.get(growing_schedule, "day_1"),
        "day_1" => Map.get(growing_schedule, "day_2"),
        "day_2" => Map.get(growing_schedule, "day_3"),
        "day_3" => Map.get(growing_schedule, "day_4"),
        "day_4" => Map.get(growing_schedule, "day_5"),
        "day_5" => Map.get(growing_schedule, "day_6"),
        "day_6" => Map.get(growing_schedule, "day_7") + Map.get(growing_schedule, "day_0"),
        "day_7" => Map.get(growing_schedule, "day_8"),
        "day_8" => Map.get(growing_schedule, "day_0")
    }
  end

  defp growing_schedule(frequencies),
    do: Enum.into(0..8, %{}, fn day -> {"day_#{day}", frequencies[day] || 0} end)

  defp produce_fishes_grows(quantity, fishes),
    do: Enum.reduce(quantity, fishes, fn _fish, fishes -> fish_growing(fishes) end)

  defp fish_growing(fishes), do: fish_growing(fishes, [])

  defp fish_growing([0 | fishes], children), do: [6 | fish_growing(fishes, [8 | children])]

  defp fish_growing([fish | fishes], children), do: [fish - 1 | fish_growing(fishes, children)]

  defp fish_growing([], children), do: Enum.reverse(children)

  defp comsume_schedule_result(data) do
    data
    |> Map.values()
    |> Enum.sum()
  end

  defp get_puzzle do
    {:ok, content} = File.read("lib/day_6/puzzle_input.txt")

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
