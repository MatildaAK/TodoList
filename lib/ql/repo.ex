defmodule Ql.Repo do
  use Ecto.Repo,
    otp_app: :ql,
    adapter: Ecto.Adapters.Postgres
end
