// TO DO
// - am I using the correct units?

// *Title* = Historic Total Community Energy Consumption Rate
// *Description* - This graph shows historical power consumption for all homes in the community, measured in watts. Use the time range selector to explore specific periods.
                // Here’s a breakdown of what you’re seeing:
                // The lines represent real-time power consumption.
                // The y-axis (labeled in watts) shows the magnitude of power consumption at each point in time.
                // The x-axis (time) tracks how the consumption fluctuates over the specified period.
// *Units* - Watts

// Declare the dynamic window period with a minimum
windowPeriodWithMin = if int(v: v.windowPeriod) <= int(v: duration(v: "20s")) then duration(v: "20s") else v.windowPeriod

// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

// display the mean of every grouping (reduces number of readings)
// we're using the minimum window period because otherwise the time window might
// not have one reading from each monitor in it (they're taken every ten seconds)
  |> aggregateWindow(every: windowPeriodWithMin, fn: mean, createEmpty: false)

// bring each individual reading into the same table for that time chunk
  |> group(columns: ["_time"])

// sum together values for each time reading
  |> sum()

// ungroup
  |> group()