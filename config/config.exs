import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
config :namedays, timezone: "Europe/Riga"

import_config "#{Mix.env()}.exs"
