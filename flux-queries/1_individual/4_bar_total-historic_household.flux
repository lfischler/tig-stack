// Initial window period as duration
initialWindowPeriod = v.windowPeriod

// Convert durations to integers (nanoseconds) for comparison
initialWindowNs = int(v: initialWindowPeriod)
oneDayNs = int(v: duration(v: "1d"))
oneHourNs = int(v: duration(v: "1h"))
timeRange = int(v: v.timeRangeStop) - int(v: v.timeRangeStart)
sevenDaysNs = 172800000000000

// Apply the maximum limit
maxWindowNs = if timeRange > sevenDaysNs then oneDayNs else initialWindowNs

// Apply the minimum limit of 1 hour
finalWindowNs = if maxWindowNs < oneHourNs then oneHourNs else maxWindowNs

// Convert the final value back to a duration
finalWindowPeriod = duration(v: finalWindowNs)


// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")
  |> drop(columns: ["host"])

// Convert values to float and calculate energy in kWh
  |> map(fn: (r) => ({ r with energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0 }))
  
  |> window(every: finalWindowPeriod)
  
  |> sum(column: "energy_kwh") // Sum hourly energy consumption in kWh

  |> duplicate(column: "_stop", as: "_time")
  |> window(every: inf)
  |> yield(name: "Energy Consumption")
