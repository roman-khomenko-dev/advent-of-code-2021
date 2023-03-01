defmodule AdventOfCode2021.GiantSquid do
  @moduledoc """
  Advent of Code 2021
  Day 4: Giant Squid
  """

  alias Board

  def game_final_score do
    {numbers, boards_data} = get_puzzle()
    boards = Enum.map(boards_data, &Board.new(&1))

    {numbers, boards}
    |> play_to_the_winning_board()
    |> score_of_the_winning_board()
  end

  defp score_of_the_winning_board({number, board}) do
      board.rows
      |> Enum.map(fn row -> Tuple.to_list(row.numbers) -- Tuple.to_list(row.mark) end)
      |> List.flatten()
      |> Enum.sum()
      |> Kernel.*(number)
  end

  defp play_to_the_winning_board({numbers, boards}) do
    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc =
        Enum.map(acc, fn board ->
          rows = append_number_if_lines_contain(number, board.rows)
          cols = append_number_if_lines_contain(number, board.cols)

          %{board | rows: rows, cols: cols}
        end)
      if any_board_win?(acc), do: {:halt, mark_board_as_winner(number, acc)}, else: {:cont, acc}
    end)
  end

  defp append_number_if_lines_contain(number, lines) do
    Enum.map(lines, fn line ->
      if is_number_in_line?(number, line.numbers),
        do: %{line | mark: Tuple.append(line.mark, number)},
        else: line
    end)
  end

  defp mark_board_as_winner(number, boards) do
    {number, boards
    |> Enum.find(&rows_or_cols_fully_marked(&1))
    |> Map.put(:winner, true)}
  end

  defp is_number_in_line?(number, line_numbers), do: number in Tuple.to_list(line_numbers)

  defp any_board_win?(boards) do
    Enum.any?(boards, &any_line_fully_marked?(&1.rows)) or Enum.any?(boards, &any_line_fully_marked?(&1.cols))
  end

  defp any_line_fully_marked?(lines), do: Enum.any?(lines, fn line -> tuple_size(line.mark) == 5 end)

  defp rows_or_cols_fully_marked(board) do
    any_line_fully_marked?(board.rows) or any_line_fully_marked?(board.cols)
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
