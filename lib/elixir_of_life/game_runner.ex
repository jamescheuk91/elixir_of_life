defmodule ElixirOfLife.GameRunner do
  require Logger
  alias ElixirOfLife.BoardServer
  alias ElixirOfLife.GenerationTickerWorker

  def run() do
    {:ok, %GenerationTickerWorker{interval: interval}} = GenerationTickerWorker.get_state
    :timer.sleep(interval)
    run_next_generation()
    run()
  end

  def run_next_generation do
    {:ok, board } = BoardServer.next_generation_state()
    ElixirOfLife.Web.GameChannel.broadcast_board_update(board)
  end
end
