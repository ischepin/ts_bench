defmodule TsBench.CRepo do
  use Ecto.Repo,
    otp_app: :ts_bench,
    adapter: ClickhouseEcto
end
