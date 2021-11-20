defmodule Namedays.DateTimeHelper do
    def get_timezone() do
      Application.fetch_env!(:namedays, :timezone)
    end

    def now do
      DateTime.now(get_timezone(), Tzdata.TimeZoneDatabase)
    end
end
