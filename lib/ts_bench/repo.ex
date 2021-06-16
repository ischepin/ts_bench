defmodule TsBench.Repo do
  use Ecto.Repo,
    otp_app: :ts_bench,
    adapter: Ecto.Adapters.Postgres
end
