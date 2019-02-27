defmodule ElixirOfLife.BoardTest do
  alias ElixirOfLife.Board, as: Board
  use ExUnit.Case, async: true

  test "add cells to board" do
    board = %Board{}
    color1 = %{red: 100, green: 100, blue: 100}
    cell_coord1 = {0, 0}
    cell1 = %{coord: cell_coord1, color: color1}
    color2 = %{red: 101, green: 101, blue: 101}
    cell_coord2 = {1, 1}
    cell2 = %{coord: cell_coord2, color: color2}
    updated_board = board |> Board.add_cells([cell1, cell2])
    assert MapSet.member?(updated_board.alive_cells, cell_coord1)
    assert Map.fetch(updated_board.alive_cell_colors, cell_coord1) == {:ok, color1}
    assert MapSet.member?(updated_board.alive_cells, cell_coord2)
    assert Map.fetch(updated_board.alive_cell_colors, cell_coord2) == {:ok, color2}
  end

  test "live cell with zero neighbour dies" do
    alive_cells = MapSet.new([{0, 0}])
    board = %Board{alive_cells: alive_cells}
    next_generation_board = Board.next_generation(board)

    refute MapSet.subset?(alive_cells, next_generation_board.alive_cells)
  end

  test "live cell with 1 neighbour dies" do
    alive_cells = MapSet.new([{0, 0}, {1, 0}])
    board = %Board{alive_cells: alive_cells}
    next_generation_board = Board.next_generation(board)

    refute MapSet.subset?(alive_cells, next_generation_board.alive_cells)
  end

  test "live cell with 2 neightours stay alive" do
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {1, 1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    assert MapSet.subset?(alive_cells, next_generation_board.alive_cells)
  end

  test "live cell with 3 neightours stay alive" do
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {2, 0}, {1, 1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    assert MapSet.subset?(alive_cells, next_generation_board.alive_cells)
  end

  test "live cell with more than 3 neightours dies" do
    the_cell = {1, 0}
    alive_cells = MapSet.new([{0, 0}, the_cell, {2, 0}, {1, 1}, {1, -1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    refute MapSet.member?(next_generation_board.alive_cells, the_cell)
  end

  test "dead cell with 2 live cell neightours stays dead" do
    the_dead_cell = {2, 0}
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {1, 1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    refute MapSet.member?(next_generation_board.alive_cells, the_dead_cell)
  end

  test "dead cell with exactly 3 live cell neightours becomes a live cell" do
    the_cell = {0, 1}
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {1, 1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    assert MapSet.member?(next_generation_board.alive_cells, the_cell)
  end

  test "dead cell will be given a color that is the average of its neighbours when is revived" do
    the_cell = {0, 1}
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {1, 1}])

    alive_cell_colors = %{
      {0, 0} => %{red: 255, green: 255, blue: 255},
      {1, 0} => %{red: 245, green: 245, blue: 245},
      {1, 1} => %{red: 235, green: 235, blue: 235}
    }

    expected_next_generation_alive_cell_colors =
      alive_cell_colors
      |> Map.put(the_cell, %{blue: 245, green: 245, red: 245})

    board = %Board{alive_cells: alive_cells, alive_cell_colors: alive_cell_colors}
    next_generation_board = Board.next_generation(board)
    assert next_generation_board.alive_cell_colors == expected_next_generation_alive_cell_colors
  end

  test "dead cell with 4 live cell neightours stays dead" do
    the_cell = {0, 0}
    alive_cells = MapSet.new([{0, 1}, {1, 0}, {0, -1}, {-1, 0}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    refute MapSet.member?(next_generation_board.alive_cells, the_cell)
  end

  test "multiple cells transform with in a iteration" do
    alive_cells = MapSet.new([{0, 0}, {1, 0}, {2, 0}, {3, 0}, {1, 1}, {2, 1}, {1, -1}, {2, -1}])
    expected_next_generation_alive_cells = MapSet.new([{0, 0}, {3, 0}, {0, 1}, {3, 1}, {0, -1}, {3, -1}])
    board = %Board{alive_cells: alive_cells, alive_cell_colors: genearte_random_cell_colors(alive_cells)}
    next_generation_board = Board.next_generation(board)

    assert MapSet.equal?(next_generation_board.alive_cells, expected_next_generation_alive_cells)
  end

  defp genearte_random_cell_colors(cells) do
    color_range = 1..255

    Enum.reduce(cells, %{}, fn cell, acc ->
      color = Enum.random(color_range)
      Map.put_new(acc, cell, %{red: color, green: color, blue: color})
    end)
  end
end
