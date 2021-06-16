defmodule TsBench.Data.ClickGenerator do
  @affiliate_id_range 1..10000
  @campaign_id_range 1..100_000
  @tracker_id_range 1..100_000

  def generate_batch(size, ts_minus, ts_plus) do
    now_unix = DateTime.utc_now() |> DateTime.to_unix()

    for _x <- 1..size do
      affiliate_id = Enum.random(@affiliate_id_range)

      %{
        affiliate_id: affiliate_id,
        campaign_id: Enum.random(@campaign_id_range),
        tracker_id: Enum.random(@tracker_id_range),
        referrer_url: referrer_url(affiliate_id),
        timestamp: timestamp(now_unix, ts_minus, ts_plus)
      }
    end
  end

  def referrer_url(affiliate_id) do
    suffix = Enum.random(1..100)
    "https://somehost#{affiliate_id}#{suffix}.com"
  end

  def timestamp(now, minus, plus) do
    start = now - minus
    finish = now + plus
    Enum.random(start..finish) |> DateTime.from_unix!()
  end
end
