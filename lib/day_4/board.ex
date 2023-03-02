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
end
