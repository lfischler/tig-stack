// *title* - Historic instantaneous power consumption
// *description* - This graph shows historical power consumption for your home, measured in watts. The lines represent real-time power consumption. The y-axis (labeled in watts) shows the magnitude of power consumption at each point in time. The x-axis (time) tracks how the consumption fluctuates over the specified period. Data is aggregated to highlight trends and provide actionable insights.
// *units* - Watts

// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["participant_no"] == "${p}")
  |> filter(fn: (r) => r["sid"] == "${sid1}")

// display the mean of every grouping (reduces number of readings)
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)

// display that mean
  |> yield(name: "mean")
