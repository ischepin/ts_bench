defmodule TsBench.Models.Bet do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "bets" do
    field :affiliate_id, :integer
    field :brand_id, :integer
    field :player_id, :integer
    field :timestamp, :utc_datetime
    field :amount, :decimal
    field :currency, :integer
    field :ggr, :decimal
    field :ngr, :decimal
  end

  @fields ~w(affiliate_id brand_id player_id amount currency ggr ngr timestamp)a
  def changeset(click, attrs) do
    click
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
