defmodule TsBench.Models.Click do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "clicks" do
    field :affiliate_id, :integer
    field :campaign_id, :integer
    field :tracker_id, :integer
    field :referrer_url, :string
    field :timestamp, :utc_datetime
  end

  @fields ~w(affiliate_id campaign_id tracker_id referrer_url timestamp)a
  def changeset(click, attrs) do
    click
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
