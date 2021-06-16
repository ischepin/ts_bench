defmodule TsBench.Data.BetGenerator do
  @affiliate_id_range 1..10000
  @brand_id_range 1..100
  @player_id_range 1..1_000_000
  @bet_amount_range 1..1_000
  @currency_range 1..100

  def generate_batch(size, ts_minus, ts_plus) do
    now_unix = DateTime.utc_now() |> DateTime.to_unix()

    for _x <- 1..size do
      affiliate_id = Enum.random(@affiliate_id_range)

      bet_amt =
        @bet_amount_range
        |> Enum.random()
        |> Decimal.new()
        |> Decimal.add(Decimal.from_float(:rand.uniform()))

      %{
        affiliate_id: affiliate_id,
        brand_id: Enum.random(@brand_id_range),
        player_id: Enum.random(@player_id_range),
        timestamp: timestamp(now_unix, ts_minus, ts_plus),
        amount: bet_amt,
        currency: Enum.random(@currency_range),
        ggr: Decimal.div(bet_amt, 2),
        ngr: Decimal.div(bet_amt, 2) |> Decimal.mult(Decimal.from_float(0.2))
      }
    end
  end

  def timestamp(now, minus, plus) do
    start = now - minus
    finish = now + plus
    Enum.random(start..finish) |> DateTime.from_unix!()
  end
end
