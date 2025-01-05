// *title* - Historic instantaneous power consumption
// *description* - This graph shows historical power consumption for your home, measured in watts. Use the time range selector to explore specific periods.
// *units* - Watt?

// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")

// display the mean of every grouping (reduces number of readings)
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)

// display that mean
  |> yield(name: "mean")
