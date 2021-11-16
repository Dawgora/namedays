defmodule Namedays.DateTimeHelper do
    def get_timezone() do
      Application.fetch_env!(:namedays, :timezone)
    end

    def now do
      get_timezone() |> DateTime.now()
    end
end
