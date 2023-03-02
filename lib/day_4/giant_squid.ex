defmodule AdventOfCode2021.GiantSquid do
  @moduledoc """
  Advent of Code 2021
  Day 4: Giant Squid
  """

  alias Board

  @spec victory_against_the_giant_squid :: number
  def victory_against_the_giant_squid do
    {numbers, boards_data} = get_puzzle()
    boards = Enum.map(boards_data, &Board.new(&1))

    {numbers, boards}
    |> play_to_the_winning_board()
    |> Board.score_of_the_winning_board()
  end

  @spec let_the_giant_squid_win :: number
  def let_the_giant_squid_win do
    {numbers, boards_data} = get_puzzle()
    boards = Enum.map(boards_data, &Board.new(&1))

    {numbers, boards}
    |> play_to_the_last_winning_board()
    |> Board.score_of_the_winning_board()
  end

  defp play_to_the_last_winning_board({numbers, boards}) do
    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc = Enum.map(acc, fn board -> Board.append_mark_if_lines_contain(number, board) end)
      acc = if Board.any_board_win_not_last?(acc), do: Board.remove_fully_marked_boards(acc), else: acc
      if Board.any_board_win_its_last?(acc), do: {:halt, Board.mark_board_as_winner(number, acc)}, else: {:cont, acc}
    end)
  end

  defp play_to_the_winning_board({numbers, boards}) do
    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc = Enum.map(acc, fn board -> Board.append_mark_if_lines_contain(number, board) end)
      if Board.any_board_win?(acc), do: {:halt, Board.mark_board_as_winner(number, acc)}, else: {:cont, acc}
    end)
  end

  @spec get_puzzle :: {list, list}
  defp get_puzzle do
    {:ok, content} = File.read("lib/day_4/puzzle_input.txt")
    [content_numbers | content_boards] = String.split(content, "\n", trim: true)

    numbers =
      content_numbers
      |> String.split(",")
      |> Enum.map(&String.to_integer(&1))

    boards =
      content_boards
      |> Enum.chunk_every(5)
      |> Enum.map(fn rows ->
        rows
        |> Enum.map(fn row ->
          row
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer(&1))
          |> List.to_tuple()
        end)
      end)

    {numbers, boards}
  end
end
