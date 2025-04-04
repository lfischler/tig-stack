// *title* - Power Consumption during Timeperiod
// *description* - This graph displays the aggregated total energy consumption (in kilowatt-hours) within your household, broken down into time blocks based on your selected time range. The graph allows you to see how much energy has been used over specific intervals (e.g., daily, weekly, monthly), with each block representing the total consumption for that period. By adjusting the time range, you can analyze patterns in your energy usage, identify peak consumption times, and make data-driven decisions to optimize your household's energy efficiency.
// *units* - kWh

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
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["participant_no"] == "${p}")
  |> filter(fn: (r) => r["sid"] == "${sid1}")
  |> drop(columns: ["host"])

  // Convert values to float and calculate energy in kWh
  |> map(fn: (r) => ({ r with energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0 }))

  |> window(every: finalWindowPeriod)
  
  |> sum(column: "energy_kwh") // Sum hourly energy consumption in kWh

  |> duplicate(column: "_stop", as: "_time")
  |> window(every: inf)
  |> yield(name: "Energy Consumption")
