// this still worked but I didn't understand the choice of units and the process wasn't as simple

// Declare the dynamic window period with a minimum of 1 minute
windowPeriodWithMin = if int(v: v.windowPeriod) <= int(v: duration(v: "1m")) then duration(v: "1m") else v.windowPeriod

// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")
  |> drop(columns: ["host", "_field", "_measurement"])

// Determine the window period dynamically, but ensure a minimum
  |> window(every: windowPeriodWithMin)

 // Convert values to float and calculate energy in kWh
  |> map(fn: (r) => ({
      r with
      energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0
  }))

  |> group(columns: ["_stop"])

// Total all readings for all sids in that time grouping
  |> sum(column: "energy_kwh")

// Ungroup to return the final result
  |> group()
