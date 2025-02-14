defmodule ElixirPhoenixApp.Repo do
  use Ecto.Repo,
    otp_app: :elixir_phoenix_app,
    adapter: Ecto.Adapters.Postgres
end
