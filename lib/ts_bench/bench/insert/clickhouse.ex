defmodule TsBench.Bench.Insert.Clickhouse do
  alias TsBench.Data.{BetGenerator, ClickGenerator}
  alias TsBench.Models.{Bet, Click}

  @dataset_size 10_000_000
  @batch_insert_size 10_000

  def insert_clicks() do
    max = Integer.floor_div(@dataset_size, @batch_insert_size)

    times =
      for _x <- 1..max do
        batch = ClickGenerator.generate_batch(@batch_insert_size, 5_000_000, 5_000_000)
        {time, {_, _}} = :timer.tc(TsBench.CRepo, :insert_all, [Click, batch])
        time
      end

    total_time = Enum.sum(times)
    avg = total_time / length(times)

    IO.puts("Total time: #{total_time / 1000} ms, average time: #{avg / 1000} ms")
  end

  def insert_bets() do
    max = Integer.floor_div(@dataset_size, @batch_insert_size)

    times =
      for _x <- 1..max do
        batch = BetGenerator.generate_batch(@batch_insert_size, 5_000_000, 5_000_000)
        {time, {_, _}} = :timer.tc(TsBench.CRepo, :insert_all, [Bet, batch])
        time
      end

    total_time = Enum.sum(times)
    avg = total_time / length(times)

    IO.puts("Total time: #{total_time / 1000} ms, average time: #{avg / 1000} ms")
  end
end
