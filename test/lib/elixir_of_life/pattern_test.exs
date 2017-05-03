defmodule ElixirOfLife.PatternTest do

  use ExUnit.Case

  alias ElixirOfLife.Pattern, as: Pattern

  test "creates a board with specified pattern" do
    pattern = """
    .@.....
    ...@...
    @@..@@@
    """

    expected_cells = MapSet.new([
      {0, 2},
      {1, 2},
      {1, 4}, {3, 3}, {4, 2}, {5, 2}, {6, 2}
    ])

    cells = Pattern.convert_to_cells(pattern, {5, 5})

    assert cells == expected_cells
  end

  test "blinker pattern" do
    expected_cells = MapSet.new([
      {5, 8}, {6, 8}, {7, 8}
    ])
    cells = Pattern.convert_to_cells(:blinker, {5, 5}, {5, 5})
    assert cells == expected_cells
  end

  test "block pattern" do
    expected_cells = MapSet.new([
      {6, 7}, {6, 8},
      {7, 7}, {7, 8}
    ])
    cells = Pattern.convert_to_cells(:block, {5, 5}, {5, 5})
    assert cells == expected_cells
  end

  test "acorn pattern" do

    expected_cells = MapSet.new([
      {8, 4} ,
      {9, 4} ,
      {9, 6} , {11, 5} , {12, 4}
    ])
    cells = Pattern.convert_to_cells(:acorn, {5, 5}, {5, 5})
    assert cells == expected_cells
  end

  test "beacon pattern" do

    expected_cells = MapSet.new([
      {6, 7}, {6, 8}, {7, 7}, {7, 8},
      {8, 5}, {8, 6}, {9, 5}, {9, 6}
    ])
    cells = Pattern.convert_to_cells(:beacon, {5, 5}, {5, 5})
    assert cells == expected_cells
  end

end
