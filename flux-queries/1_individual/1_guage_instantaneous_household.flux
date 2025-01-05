// *title* - Household energy consumption rate now
// *description* - This graph shows historical power consumption for your home, measured in watts. 
                // Here’s a breakdown of what you’re seeing:
                // The lines represent real-time power consumption.
                // The y-axis (labeled in watts) shows the magnitude of power consumption at each point in time.
                // The x-axis (time) tracks how the consumption fluctuates over the specified period.
// *units* - Watt?

// get required data
from(bucket: "telegraf")
  |> range(start: -5m)  // Last 5 minutes
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")

  |> group(columns: ["sid"])  // Group by SID to handle each SID separately
  |> last()  // Get the most recent reading for each SID

from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["host"] == "ead1191f2d2a")
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "mean")