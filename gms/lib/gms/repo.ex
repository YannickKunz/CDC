defmodule Gms.Repo do
  use Ecto.Repo,
    otp_app: :gms,
    adapter: Ecto.Adapters.Postgres
end
