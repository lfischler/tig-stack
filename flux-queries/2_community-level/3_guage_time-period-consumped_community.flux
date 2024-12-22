// Gets the data from the telegraf bucket and records it in the correct columns
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

// turn instantaneous reading into wh consumed over time period (10 seconds)
  |> map(fn: (r) => ({ r with energy_wh: float(v: r._value) * (10.0 / 3600.0) }))
  |> drop(columns: ["_value"])

// group all readings by minute period
  |> group(columns: ["_measurement"])

// generate sum of energy_wh in each group
  |> sum(column: "energy_wh")

// convert values into kwh
  |> map(fn: (r) => ({ r with energy_kwh: r.energy_wh / 1000.0 }))
  |> drop(columns: ["energy_wh"])

  |> yield(name: "Total Energy Consumption")
