defmodule ElixirOfLife.Web.GameChannel do

  @moduledoc """
    Socket channel to handle game read-time updates
  """

  use Phoenix.Channel
  alias ElixirOfLife.BoardServer
  require Logger

  intercept ["board_update"]


  def join("game:lobby", _message, socket) do
    message = get_current_board() |> convert_board_format
    {:ok, message, socket}
  end

  def join("game:" <> _game_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("add_cells", %{"cells" => cells}, socket) do
    updated_board = add_cells_to_current_board(cells)
    message = updated_board |> convert_board_format
    broadcast_board_update(updated_board)
    {:reply, {:ok, message}, socket}
  end

  def handle_out("board_update", %{board: board}, socket) do
    message = board |> convert_board_format
    push socket, "board_update", message
    {:noreply, socket}
  end

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def broadcast_board_update(board) do
    Logger.debug("ElixirOfLife.Web.GameChannel:broadcast_board_update #{inspect board}")
    ElixirOfLife.Endpoint.broadcast! "game:lobby", "board_update", %{board: board}
  end

  defp get_current_board() do
    {:ok, board } = BoardServer.current_board()
    board
  end

  defp add_cells_to_current_board(cells) do
    {:ok, board } =  BoardServer.add_cells(cells |> convert_cells_format)
    board
  end

  defp convert_board_format(board) do
    {colsSize, rowsSize} = board.size
    alive_cells_map = board.alive_cells |> convert_to_alive_cells_map(board.alive_cell_colors)
    %{
      generation: board.generation,
      size: %{
        cols: colsSize,
        rows: rowsSize
      },
      live_cells: alive_cells_map
    }
  end

  defp convert_to_alive_cells_map(alive_cells, alive_cell_colors) do
    alive_cells
    |> MapSet.to_list
    |> Enum.reduce(Map.new(), fn(cell, acc) ->
      {col, row} = cell
      color_hex = alive_cell_colors[cell] |> convert_rgb_to_hex
      updated_row_map = case Map.fetch(acc, "#{col}")  do
        {:ok, row_map} -> Map.put(row_map, "#{row}", %{color: color_hex})
        :error -> Map.put(%{}, "#{row}", %{color: color_hex})
      end
      Map.put(acc, "#{col}", updated_row_map)
    end)
  end

  defp convert_cells_format(cells) do
    cells
    |> Enum.map(&convert_cell_format(&1))
  end

  defp convert_cell_format(%{"col" => col, "row" => row, "color" => color_hex}) do
    cell_coord = {col, row}

    color_rgb = color_hex |> String.upcase |> convert_hex_to_rgb
    %{coord: cell_coord, color: color_rgb}
  end

  defp convert_hex_to_rgb(hex) do
    %ColorUtils.RGB{red: red, green: green, blue: blue} = ColorUtils.hex_to_rgb(hex)
    %{red: round(red), green: round(green), blue: round(blue)}
  end

  defp convert_rgb_to_hex(%{red: red, green: green, blue: blue}) do

    rgb = %ColorUtils.RGB{red: red, green: green, blue: blue}

    ColorUtils.rgb_to_hex(rgb)
  end
end
