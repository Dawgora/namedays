import Config

config :namedays,
  content_files: [
    'resources/namedays.json',
    'resources/namedays-extended.json'
  ],
  timezone: "Europe/Riga"

  config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase
