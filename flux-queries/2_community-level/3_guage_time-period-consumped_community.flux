// *title* - Power consumed by community during time period selected
// *description* - 
// *units* - kWh

// Gets the data from the telegraf bucket and records it in the correct columns
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

// turn instantaneous reading into kwh consumed over time period (10 seconds)
  |> map(fn: (r) => ({ r with energy_kwh: float(v: r._value) * (10.0 / 3600.0) / 1000.0}))
  |> drop(columns: ["_value"])

  // group all readings to bring them all into the same table
  |> group(columns: ["_measurement"])

  // generate sum of energy_wh
  |> sum(column: "energy_kwh")

  |> yield(name: "Total Energy Consumption")