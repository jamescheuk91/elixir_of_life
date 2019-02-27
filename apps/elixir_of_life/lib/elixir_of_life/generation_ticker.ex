defmodule ElixirOfLife.GenerationTicker do
  use GenServer
  require Logger
  alias ElixirOfLife.EventWorker
  alias ElixirOfLife.GenerationTicker

  @default_name {:global, __MODULE__}
  @default_interval_ms 2000

  defstruct(interval: @default_interval_ms)

  def start_link() do
    case GenServer.start_link(__MODULE__, %GenerationTicker{}, name: @default_name) do
      {:ok, pid} ->
        Logger.info("Started #{__MODULE__}")
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("Slready Started #{__MODULE__}")
        {:ok, pid}
    end
  end

  def handle_call(:get_ticker, _from, ticker) do
    Logger.debug("GenerationTickerWorker:get_ticker:{interval: #{ticker.interval}}")
    {:reply, {:ok, ticker}, ticker}
  end

  def handle_call({:set_interval, new_interval}, _from, state) do
    new_state = %{state | interval: new_interval}
    GenEvent.notify(EventWorker, {:ticker_update, new_state})
    {:reply, :ok, new_state}
  end

  def set_interval(interval) do
    GenServer.call(@default_name, {:set_interval, interval})
  end

  def get_state do
    GenServer.call(@default_name, :get_ticker)
  end
end
