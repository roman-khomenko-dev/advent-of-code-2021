defmodule AdventOfCode2021.Lanternfish do
  @moduledoc """
  Advent of Code 2021
  Day 6: Lanternfish
  """
  alias Nx

  import Nx.Defn

  def lanternfish_growing(start_fish_quantity \\ 80) do
    growing_schedule = get_puzzle() |> growing_schedule()

    1..start_fish_quantity
    |> Enum.to_list()
    |> Nx.tensor()
    |> produce_fishes_grows(growing_schedule)
    |> Nx.sum()
  end

  def lanternfish_unlimited_growing(start_fish_quantity \\ 256) do
    lanternfish_growing(start_fish_quantity)
  end

  defn proceed_growing(growing_schedule) do
    new_schedule = Nx.take(growing_schedule, Nx.tensor([1, 2, 3, 4, 5, 6, 7, 8, 0]))

    growth_fish = Nx.squeeze(Nx.tensor([0]))

    Nx.indexed_add(
      new_schedule,
      Nx.tensor([[6, 0]]),
      Nx.take(growing_schedule, growth_fish)
    )
  end

  defp growing_schedule(fishes) do
    with frequencies <- fishes |> Enum.frequencies(),
         fishes_timer <-
           Enum.into(0..8, [], fn day ->
             if Map.has_key?(frequencies, day), do: [Map.get(frequencies, day)], else: [0]
           end) do
      Nx.tensor(fishes_timer)
    end
  end

  defn produce_fishes_grows(quantity, fishes) do
    while fishes, _i <- quantity do
      proceed_growing(fishes)
    end
  end

  defp get_puzzle do
    {:ok, content} = File.read("lib/day_6/puzzle_input.txt")

    content
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end
end
