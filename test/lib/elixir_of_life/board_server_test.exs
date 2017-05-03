defmodule ElixirOfLife.BoardServerTest do
  use ExUnit.Case, async: false

  alias ElixirOfLife.BoardServer

  setup do
    {:ok, board_server_pid} = BoardServer.start_link()

    on_exit fn ->
      if Process.alive?(board_server_pid), do: GenServer.stop(board_server_pid)
    end

    :ok
  end

  test "get current board state" do
    {:ok, board} = BoardServer.current_board()
    assert board.generation == 0
  end

  test "get next board state" do
    {:ok, board} = BoardServer.next_generation_state()
    assert board.generation == 1
  end

  test "gets next board state multiple times" do
    {:ok, _} = BoardServer.next_generation_state()
    {:ok, _} = BoardServer.next_generation_state()
    {:ok, board} = BoardServer.next_generation_state()
    assert board.generation == 3
  end

  test "add cells to board" do
    cell_coord = {1, 1}
    color = %{red: 100, green: 100, blue: 100}
    cell = %{coord: cell_coord, color: color}
    {:ok, updated_board} = BoardServer.add_cells([cell])
    assert MapSet.member?(updated_board.alive_cells, cell_coord)
    assert Map.fetch(updated_board.alive_cell_colors, cell_coord) == {:ok, color}
  end

end
