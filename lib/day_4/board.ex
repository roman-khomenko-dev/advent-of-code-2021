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

  @spec score(atom | %{:rows => any, optional(any) => any}) :: list
  def score(board), do: Enum.map(board.rows, fn row -> Tuple.to_list(row.numbers) -- Tuple.to_list(row.mark) end)

  @spec append_mark(any, %{:cols => any, :rows => any, optional(any) => any}) ::
          %{:cols => list, :rows => list, optional(any) => any}
  def append_mark(number, board) do
    %{board | rows: mark_number(number, board.rows), cols: mark_number(number, board.cols)}
  end

  @spec mark_number(any, any) :: list
  def mark_number(number, lines) do
    Enum.map(lines, fn line ->
      if is_number_in_line?(number, line.numbers),
        do: %{line | mark: Tuple.append(line.mark, number)},
        else: line
    end)
  end

  @spec line_fully_marked(atom | %{:rows => any, optional(any) => any}) :: boolean
  def line_fully_marked(board) do
    any_line_marked?(board.rows) or any_line_marked?(board.cols)
  end

  @spec any_line_marked?(any) :: boolean
  def any_line_marked?(lines), do: Enum.any?(lines, fn line -> tuple_size(line.mark) == 5 end)

  defp is_number_in_line?(number, line_numbers), do: number in Tuple.to_list(line_numbers)
end
