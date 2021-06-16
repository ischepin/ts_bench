defmodule TsBench.Bench.Select.Clickhouse do
  import Ecto.Query

  alias TsBench.Models.Click

  # sum of all clicks for affiliate for a week per day grouped by day,campaign_id
  def sum_affiliate_clicks(affiliate_id) do
    q =
      from(
        c in Click,
        where:
          c.affiliate_id == ^affiliate_id and fragment("timestamp >= '2021-07-07'") and
            fragment("timestamp <= '2021-07-13'"),
        select: [c.campaign_id, count(), fragment("toYYYYMMDD(?) as day", c.timestamp)],
        group_by: [fragment("day, campaign_id")]
      )

    {time, value} = :timer.tc(TsBench.CRepo, :all, [q])
    time / 1000
  end

  # month 2021-06, clicks per day per campaign, order by most clicks first
  def clicks_per_day_per_campaign(affiliate_id) do
    q =
      from(
        c in Click,
        where:
          c.affiliate_id == ^affiliate_id and
            fragment("timestamp >= '2021-06-01' and timestamp < '2021-07-01'"),
        select: [
          c.campaign_id,
          fragment("count() as click_count"),
          fragment("toYYYYMMDD(?) as day", c.timestamp)
        ],
        group_by: [fragment("day, campaign_id")],
        order_by: fragment("click_count desc")
      )

    {time, value} = :timer.tc(TsBench.CRepo, :all, [q])
    time / 1000
  end

  # query materialized view 'monthly_clicks_per_campaign'
  def monthly_clicks_per_campaign_view(campaign_id) do
    q =
      "select month, sum(clicks) from monthly_clicks_per_campaign where campaign_id = #{
        campaign_id
      } group by month"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  # same but without view
  def monthly_clicks_per_campaign(campaign_id) do
    q =
      "select toYYYYMM(timestamp) as month, count() as clicks from clicks where campaign_id = #{
        campaign_id
      } group by month"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  # top 10 campaigns of June 2021
  def top10_june_campaigns() do
    q =
      "select campaign_id, count() as click_cnt from clicks where toYYYYMM(timestamp) = 202106 group by campaign_id order by click_cnt desc limit 10"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  def daily_clicks_per_campaign_view(campaign_id) do
    q =
      "select day, sum(clicks) from daily_clicks_per_campaign where campaign_id = #{campaign_id} group by day"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  def daily_clicks_per_campaign(campaign_id) do
    q =
      "select toYYYYMMDD(timestamp) as day, count() as clicks from clicks where campaign_id = #{
        campaign_id
      } group by day"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  # period 2021-06-08:2021-06-10
  def hourly_clicks_per_campaign_view(campaign_id) do
    q =
      "select hour, sum(clicks) from hourly_clicks_per_campaign where campaign_id = #{campaign_id} and hour >= '2021-06-08' and hour < '2021-06-10' group by hour"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  # period 2021-06-08:2021-06-10
  def hourly_clicks_per_campaign(campaign_id) do
    q =
      "select toStartOfHour(timestamp) as hour, count(*) as clicks from clicks where campaign_id = #{
        campaign_id
      } and timestamp >= '2021-06-08' and timestamp < '2021-06-10' group by hour"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  def total_monthly_ngr_for_affiliate(affiliate_id) do
    q =
      "select toYYYYMM(timestamp) as month, sum(ngr), brand_id as total_ngr from bets where affiliate_id = #{
        affiliate_id
      } group by month, brand_id"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  def ngr_for_period(affiliate_id) do
    q =
      "select sum(ngr), brand_id from bets where affiliate_id = #{affiliate_id} and timestamp >= '2021-06-01' and timestamp < '2021-07-01' group by brand_id"

    {time, value} = :timer.tc(TsBench.CRepo, :query, [q])
    time / 1000
  end

  def top_10_affiliates_by_ngr_in_june() do
    q =
      "select sum(ngr) as total_ngr, affiliate_id from bets where timestamp >= '2021-06-01' and timestamp < '2021-07-01' group by affiliate_id order by total_ngr desc limit 10"

    {time, value} = :timer.tc(TsBench.Repo, :query, [q])
    time / 1000
  end

  def top_10_affiliates_by_ngr_in_june_view() do
    q =
      "select affiliate_id, month, total_ngr from top_10_monthly_affiliates where month = 202106 order by total_ngr desc limit 10"

    {time, value} = :timer.tc(TsBench.Repo, :query, [q])
    time / 1000
  end
end
