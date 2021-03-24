defmodule Freshy.Repo do
  use Ecto.Repo,
    otp_app: :freshy,
    adapter: Ecto.Adapters.Postgres
end
