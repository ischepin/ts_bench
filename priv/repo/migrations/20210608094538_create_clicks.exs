defmodule TsBench.Repo.Migrations.CreateClicks do
  use Ecto.Migration

  def change do
    create table("clicks", primary_key: false) do
      add :timestamp, :naive_datetime, null: false
      add :affiliate_id, :integer, null: false
      add :campaign_id, :integer, null: false
      add :tracker_id, :decimal, null: false
      add :referrer_url, :string, null: false
    end

    execute("SELECT create_hypertable('clicks', 'timestamp')", "")
  end
end
