// get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")

 // Convert values to float and calculate energy in kWh
  |> map(fn: (r) => ({
      r with
      energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0
  }))

  |> sum(column: "energy_kwh") // Total energy in Wh for the range
  
  |> yield(name: "Total Energy Consumption")
