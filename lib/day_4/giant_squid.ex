defmodule AdventOfCode2021.GiantSquid do
  @moduledoc """
  Advent of Code 2021
  Day 4: Giant Squid
  """

  alias Board

  @spec victory_against_giant_squid :: number
  def victory_against_giant_squid do
    {numbers, boards_data} = get_puzzle()
    boards = Enum.map(boards_data, &Board.new(&1))

    {numbers, boards}
    |> first_board_victory()
    |> winning_board_score()
  end

  @spec let_giant_squid_win :: number
  def let_giant_squid_win do
    {numbers, boards_data} = get_puzzle()
    boards = Enum.map(boards_data, &Board.new(&1))

    {numbers, boards}
    |> last_board_victory()
    |> winning_board_score()
  end

  defp last_board_victory({numbers, boards}) do
    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc =
        {number, acc}
        |> mark_boards()
        |> process_win_board()
      if last_board_win?(acc), do: {:halt, mark_board_as_winner(number, acc)}, else: {:cont, acc}
    end)
  end

  defp first_board_victory({numbers, boards}) do
    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc = Enum.map(acc, fn board -> Board.append_mark(number, board) end)
      if any_board_win?(acc), do: {:halt, mark_board_as_winner(number, acc)}, else: {:cont, acc}
    end)
  end

  defp process_win_board(boards) do
    if first_board_win?(boards), do: remove_marked_boards(boards), else: boards
  end

  defp mark_boards({number, boards}) do
    Enum.map(boards, fn board -> Board.append_mark(number, board) end)
  end

  @spec winning_board_score({number, atom | %{:rows => any, optional(any) => any}}) ::
  number
  def winning_board_score({number, board}) do
    board
    |> Board.score()
    |> List.flatten()
    |> Enum.sum()
    |> Kernel.*(number)
  end

  @spec first_board_win?(any) :: boolean
  def first_board_win?(boards), do: any_board_win?(boards) && Enum.count(boards) > 1

  @spec last_board_win?(any) :: boolean
  def last_board_win?(boards), do: any_board_win?(boards) && Enum.count(boards) == 1

  @spec any_board_win?(any) :: boolean
  def any_board_win?(boards) do
    Enum.any?(boards, &Board.line_fully_marked(&1))
  end

  @spec remove_marked_boards(list) :: list
  def remove_marked_boards([_last_board] = boards), do: boards

  def remove_marked_boards(boards) do
    boards -- Enum.filter(boards, &Board.line_fully_marked(&1))
  end

  @spec mark_board_as_winner(any, any) :: {any, %{:winner => true, optional(any) => any}}
  def mark_board_as_winner(number, boards) do
    {number, boards
    |> Enum.find(&Board.line_fully_marked(&1))
    |> Map.put(:winner, true)}
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
