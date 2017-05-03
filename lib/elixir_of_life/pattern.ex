defmodule ElixirOfLife.Pattern do

  def convert_to_cells(pattern, {_, size_y}) do
    pattern
    |> String.split("\n", trim: true)
    |> Stream.with_index
    |> Stream.flat_map(fn({line_str, index}) -> load_line(line_str, size_y - index - 1) end)
    |> MapSet.new
  end

  defp load_line(pattern_line, y_coord) do
    pattern_line
    |> String.graphemes
    |> Stream.with_index
    |> Stream.filter(&(match?({"@", _}, &1)))
    |> Enum.map(fn({_, x_coord}) -> {x_coord, y_coord} end)
  end

  def convert_to_cells(:blinker, {origin_x, origin_y}, {size_x, size_y}) do
    pattern = """
    ....
    @@@
    ...
    """
    convert_to_predefined_cells_pattern(pattern, {origin_x, origin_y}, {size_x, size_y})
  end

  def convert_to_cells(:block, {origin_x, origin_y}, {size_x, size_y}) do
    pattern = """
    ....
    .@@.
    .@@.
    ....
    """
    convert_to_predefined_cells_pattern(pattern, {origin_x, origin_y}, {size_x, size_y})
  end

  def convert_to_cells(:acorn, {origin_x, origin_y}, {size_x, size_y}) do
    pattern = """
    .@.....
    ...@...
    @@..@@@
    """
    convert_to_predefined_cells_pattern(pattern, {origin_x+round(size_x/2), origin_y-round(size_y/2)}, {size_x, size_y})
  end

  def convert_to_cells(:beacon, {origin_x, origin_y}, {size_x, size_y}) do
    pattern = """
    ......
    .@@...
    .@@...
    ...@@.
    ...@@.
    ......
    """
    convert_to_predefined_cells_pattern(pattern, {origin_x, origin_y}, {size_x, size_y})
  end



  def convert_to_predefined_cells_pattern(pattern, {origin_x, origin_y}, {size_x, size_y}) do
    convert_to_cells(pattern, {size_x, size_y})
      |> Stream.map(fn({x,y}) ->  {x + origin_x, y + origin_y } end)
      |> Stream.filter(fn({x,y}) -> (x - origin_x) < size_x && (y - origin_y) < size_y end)
      |> MapSet.new
  end
end
