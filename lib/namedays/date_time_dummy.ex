defmodule Namedays.DateTimeHelperDummy do
    defdelegate get_timezone(), to: Namedays.DateTimeHelper, as: :get_timezone

    def now do
       DateTime.new(~D[2021-01-22], ~T[00:00:00.000], get_timezone())
    end
end
