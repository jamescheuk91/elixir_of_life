defmodule ElixirOfLife.Board do
  @moduledoc """
    The logic for Conway's Game of Life.

    Cell is tracked as a tulpe that represents its coordinate and color
    E.g. {1, 2} = Column 1, Row 2

    Cell's color is tracked as a map with its coordinate as a key .
    E.g. %{{1, 2} => %{red: 255, green: 255, blue: 255}} = For Column 1, Row 2, the RGB is 255, 255, 255

    On each generation of the game, a list of neighbours
    for all alive cells will be gathered. Then the next state for each cells will be calculated.
  """
  @default_size {100, 60}

  defstruct(
    generation: 0,
    size: @default_size,
    alive_cells: %MapSet{},
    alive_cell_colors: %{}
  )

  @neigbour_vectors [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  @doc """
    Add cell and cell color to board
    Return a new board containing the new cell and cell color.
  """

  def add_cells(%ElixirOfLife.Board{} = board, cells) do
    cells
    |> Enum.reduce(board, fn %{coord: coord, color: color}, acc ->
      add_cell(acc, {coord, color})
    end)
  end

  defp add_cell(%ElixirOfLife.Board{} = board, {cell_coord, color}) do
    alive_cells = MapSet.put(board.alive_cells, cell_coord)
    alive_cell_colors = Map.put_new(board.alive_cell_colors, cell_coord, color)
    %{board | alive_cells: alive_cells, alive_cell_colors: alive_cell_colors}
  end

  @doc """
    Transform current board state to the next generation.
    Returns a new board
  """

  def next_generation(%ElixirOfLife.Board{} = board) do
    current_alive_cells = board.alive_cells
    current_alive_cell_colors = board.alive_cell_colors
    next_alive_cells = next_generation_alive_cells(current_alive_cells)

    next_alive_cell_colors =
      next_generation_alive_cell_colors(current_alive_cell_colors, current_alive_cells, next_alive_cells)

    %{
      board
      | generation: board.generation + 1,
        alive_cells: next_alive_cells,
        alive_cell_colors: next_alive_cell_colors
    }
  end

  @doc """
    Return a Mapset containing a list of alive cells in next generation.
  """
  def next_generation_alive_cells(%MapSet{} = current_alive_cells) do
    current_alive_cells
    |> gather_target_cells
    |> Stream.map(&{&1, next_cell_state(current_alive_cells, &1)})
    |> Stream.filter_map(fn {_cell, next_state} -> next_state == :alive end, fn {cell, _next_state} -> cell end)
    |> MapSet.new()
  end

  @doc """
    Return a Map for alive cell colors in next generation.
  """

  def next_generation_alive_cell_colors(
        %{} = current_alive_cell_colors,
        %MapSet{} = current_alive_cells,
        %MapSet{} = next_alive_cells
      ) do
    current_alive_cell_colors
    |> put_newborn_cell_colors(current_alive_cells, next_alive_cells)
    |> drop_deal_cell_colors(current_alive_cells, next_alive_cells)
  end

  @doc """
    Returns a MapSet containing a list of alive and dead neightour cells.
  """

  def gather_target_cells(%MapSet{} = alive_cells) do
    alive_cells
    |> Stream.flat_map(&[&1 | cell_neightours(&1)])
    |> MapSet.new()
  end

  @doc """
    Returns a list of neightour cells given a live cell.
  """

  def cell_neightours({cell_x, cell_y}) do
    @neigbour_vectors
    |> Enum.map(fn {x, y} -> {cell_x + x, cell_y + y} end)
  end

  defp next_cell_state(alive_cells, cell) do
    current_state = current_cell_state(alive_cells, cell)
    alive_neighbours = alive_neighbours(alive_cells, cell)

    case {current_state, MapSet.size(alive_neighbours)} do
      {:alive, 2} -> :alive
      {:alive, 3} -> :alive
      {:dead, 3} -> :alive
      _ -> :dead
    end
  end

  # """
  #   Returns a atom to indicate the cell's current state
  # """

  defp current_cell_state(alive_cells, cell) do
    case MapSet.member?(alive_cells, cell) do
      true -> :alive
      false -> :dead
    end
  end

  # """
  #   Returns a list of alive neightours given a cell
  # """
  defp alive_neighbours(alive_cells, cell) do
    surrounding_neightours = cell_neightours(cell) |> MapSet.new()
    MapSet.intersection(alive_cells, surrounding_neightours)
  end

  defp put_newborn_cell_colors(cell_colors, %MapSet{} = current_alive_cells, %MapSet{} = next_alive_cells) do
    newborn_cells = MapSet.difference(next_alive_cells, current_alive_cells)

    newborn_cells
    |> Stream.map(&{&1, MapSet.new(cell_neightours(&1))})
    |> Stream.map(fn {new_cell, cell_neightours} ->
      alive_cell_neightours = MapSet.intersection(current_alive_cells, cell_neightours)
      {new_cell, alive_cell_neightours}
    end)
    |> Stream.map(fn {new_cell, cells} ->
      colors = gather_cell_colors(cell_colors, cells)
      {new_cell, colors}
    end)
    |> Enum.reduce(cell_colors, fn {new_cell, colors}, cell_colors_acc ->
      Map.put_new(cell_colors_acc, new_cell, average_cell_rgb_colors(colors))
    end)
  end

  defp drop_deal_cell_colors(cell_colors, %MapSet{} = current_alive_cells, %MapSet{} = next_alive_cells) do
    die_off_cells = MapSet.difference(current_alive_cells, next_alive_cells)
    Map.drop(cell_colors, MapSet.to_list(die_off_cells))
  end

  defp gather_cell_colors(cell_colors, cells) do
    cells
    |> Enum.reduce([], fn cell, acc ->
      case Map.fetch(cell_colors, cell) do
        {:ok, color} -> acc ++ [color]
        :error -> acc
      end
    end)
  end

  defp average_cell_rgb_colors(colors) do
    color_length = length(colors)

    colors
    |> Enum.reduce([red: 0, green: 0, blue: 0], fn %{red: red, green: green, blue: blue}, acc ->
      [red: acc[:red] + red, green: acc[:green] + green, blue: acc[:blue] + blue]
    end)
    |> Stream.map(fn {key, color_value} ->
      average_color = div(color_value, color_length)
      {key, average_color}
    end)
    |> Enum.into(%{})
  end
end
