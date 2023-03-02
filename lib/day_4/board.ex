defmodule Board do
  @moduledoc """
  Bingo game board struct
  """
  defstruct rows: [], cols: [], winner: false

  def new(board) do
    %Board{
      rows: Enum.with_index(board, fn row, index -> %{index: index, numbers: row, mark: {}} end),
      cols:
        Enum.with_index(board, fn _row, index ->
          %{
            index: index,
            numbers: board |> Enum.map(&elem(&1, index)) |> List.to_tuple(),
            mark: {}
          }
        end)
    }
  end

  @spec score_of_the_winning_board({number, atom | %{:rows => any, optional(any) => any}}) ::
          number
  def score_of_the_winning_board({number, board}) do
    board.rows
    |> Enum.map(fn row -> Tuple.to_list(row.numbers) -- Tuple.to_list(row.mark) end)
    |> List.flatten()
    |> Enum.sum()
    |> Kernel.*(number)
  end

  @spec append_mark_if_lines_contain(any, %{:cols => any, :rows => any, optional(any) => any}) ::
          %{:cols => list, :rows => list, optional(any) => any}
  def append_mark_if_lines_contain(number, board) do
    rows = map_number_if_lines_contain(number, board.rows)
    cols = map_number_if_lines_contain(number, board.cols)
    %{board | rows: rows, cols: cols}
  end

  @spec map_number_if_lines_contain(any, any) :: list
  def map_number_if_lines_contain(number, lines) do
    Enum.map(lines, fn line ->
      if is_number_in_line?(number, line.numbers),
        do: %{line | mark: Tuple.append(line.mark, number)},
        else: line
    end)
  end

  @spec any_board_win_not_last?(any) :: boolean
  def any_board_win_not_last?(boards), do: any_board_win?(boards) && Enum.count(boards) > 1

  @spec any_board_win_its_last?(any) :: boolean
  def any_board_win_its_last?(boards), do: any_board_win?(boards) && Enum.count(boards) == 1

  @spec remove_fully_marked_boards(list) :: list
  def remove_fully_marked_boards([_last_board] = boards), do: boards

  def remove_fully_marked_boards(boards) do
    boards -- Enum.filter(boards, &rows_or_cols_fully_marked(&1))
  end

  @spec mark_board_as_winner(any, any) :: {any, %{:winner => true, optional(any) => any}}
  def mark_board_as_winner(number, boards) do
    {number, boards
    |> Enum.find(&rows_or_cols_fully_marked(&1))
    |> Map.put(:winner, true)}
  end

  @spec any_board_win?(any) :: boolean
  def any_board_win?(boards) do
    Enum.any?(boards, &any_line_fully_marked?(&1.rows)) or Enum.any?(boards, &any_line_fully_marked?(&1.cols))
  end

  defp any_line_fully_marked?(lines), do: Enum.any?(lines, fn line -> tuple_size(line.mark) == 5 end)

  defp rows_or_cols_fully_marked(board) do
    any_line_fully_marked?(board.rows) or any_line_fully_marked?(board.cols)
  end

  defp is_number_in_line?(number, line_numbers), do: number in Tuple.to_list(line_numbers)
end
