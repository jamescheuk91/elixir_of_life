defmodule ElixirOfLife.BoardServer do
  alias ElixirOfLife.Board
  use GenServer
  require Logger


  @default_name {:global, __MODULE__}
  @default_board %ElixirOfLife.Board{}


  def start_link() do
    case GenServer.start_link(__MODULE__, @default_board, name: @default_name) do
      {:ok, pid} ->
        Logger.info "Started #{__MODULE__}"
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        Logger.info "Already Started #{__MODULE__}"
        {:ok, pid}
    end
  end

  ## handle Server Callbacks

  def handle_call({:add_cells, %{coord: _coord, color: _color, pattern: nil} = cell}, _from, board) do
    updated_board = Board.add_cells(board, [cell])
    Logger.debug("BoardServer:add_cells: #{inspect updated_board}")
    {:reply, {:ok, updated_board}, updated_board}
  end


  def handle_call({:add_cells, %{coord: coord, color: color, pattern: pattern}}, _from, board) do
    pattern = pattern |> String.to_atom

    cells = ElixirOfLife.Pattern.get_cells_pattern(pattern, coord)
              |> Enum.map(fn(coord) ->
                %{coord: coord, color: color}
              end)
    updated_board = Board.add_cells(board, cells)
    Logger.debug("BoardServer:add_cells: #{inspect updated_board}")
    {:reply, {:ok, updated_board}, updated_board}
  end

  def handle_call(:next_generation_state, _from, board) do
    updated_board = Board.next_generation(board)
    Logger.debug("BoardServer:next_generation_state: #{inspect updated_board}")
    {:reply, {:ok, updated_board}, updated_board}
  end

  def handle_call(:current_board, _from, board) do
    Logger.debug("BoardServer:current_board: #{inspect board}")
    {:reply, {:ok, board}, board}
  end

  ## BoardServer API

  def add_cells(cells) do
    GenServer.call(@default_name, {:add_cells, cells})
  end

  def next_generation_state() do
    GenServer.call(@default_name, :next_generation_state)
  end

  def current_board() do
    GenServer.call(@default_name, :current_board)
  end

end
