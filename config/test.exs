import Config

config :namedays, content_files: [
  "priv/resources/namedays-test.json"
],
datetime_implementation: Namedays.DateTimeHelperDummy,
timezone: "Europe/Riga"
