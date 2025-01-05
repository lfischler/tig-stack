// *title* - 
// *description* - 
// *units* - kWh
// *setup* - Set x axis as "Time"

// Initial window period as duration
initialWindowPeriod = v.windowPeriod

// Convert durations to integers (nanoseconds) for comparison
initialWindowNs = int(v: initialWindowPeriod)
oneDayNs = int(v: duration(v: "1d"))
oneHourNs = int(v: duration(v: "1h"))
timeRange = int(v: v.timeRangeStop) - int(v: v.timeRangeStart)
sixDaysNs = int(v: duration(v: "6d"))

// Apply the maximum limit
maxWindowNs = if timeRange > sixDaysNs then oneDayNs else initialWindowNs

// Apply the minimum limit of 1 hour
finalWindowNs = if maxWindowNs < oneHourNs then oneHourNs else maxWindowNs

// Convert the final value back to a duration
finalWindowPeriod = duration(v: finalWindowNs)


// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

  // Convert values to float and calculate energy in kWh
  |> map(fn: (r) => ({ r with energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0 }))

  |> aggregateWindow(every: finalWindowPeriod, fn: sum, createEmpty: false)

// bring each individual reading into the same table for that time chunk
  |> group(columns: ["_time"])

    // sum together values for each time reading
  |> sum()

  // ungroup
  |> group()

  |> yield(name: "Energy Consumption")
