import Config

config :namedays, content_files: [
  'test/resources/namedays.json'
],
datetime_implementation: Namedays.DateTimeHelperDummy
