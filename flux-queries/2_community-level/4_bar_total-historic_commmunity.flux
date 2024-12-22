// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

// Convert values to float and calculate energy in Wh
  |> map(fn: (r) => ({ r with energy_wh: (float(v: r._value) * (10.0 / 3600.0)) }))

  |> window(every: 1h)
  |> sum(column: "energy_wh") // Sum hourly energy consumption in Wh

  |> map(fn: (r) => ({ 
       r with energy_kwh: r.energy_wh / 1000.0 // Convert Wh to kWh
     }))

  |> drop(columns: ["energy_wh"])

  |> duplicate(column: "_stop", as: "_time")
  |> window(every: inf)

  |> group(columns: ["_time"])
  |> sum(column: "energy_kwh")
  |> group()

  |> yield(name: "Energy Consumption")
