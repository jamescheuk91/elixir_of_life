defmodule ElixirOfLife.GenerationTickerWorkerTest do
  use ExUnit.Case, async: false
  alias ElixirOfLife.GenerationTickerWorker

  setup do
    ElixirOfLife.EventWorker.start_link
    {:ok, ticker_pid }  = GenerationTickerWorker.start_link()
    on_exit fn ->
      if Process.alive?(ticker_pid), do: GenServer.stop(ticker_pid)
    end

    {:ok, ticker_pid: ticker_pid}
  end


  test "set interval" do
    new_interval = 666
    :ok = GenerationTickerWorker.set_interval(new_interval)
    {:ok, ticker} = GenerationTickerWorker.get_state

    assert ticker.interval == new_interval
  end

  test "get state" do
    {:ok, ticker} = GenerationTickerWorker.get_state
    assert ticker == %ElixirOfLife.GenerationTickerWorker{}
  end

end
