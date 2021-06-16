defmodule TsBench.Repo.Migrations.CreateClicks do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:clicks, engine: "MergeTree") do
      add :timestamp, :naive_datetime, null: false
      add :affiliate_id, :integer, null: false
      add :campaign_id, :integer, null: false
      add :tracker_id, :integer, null: false
      add :referrer_url, :string, null: false
    end
  end
end
