// *title* - Community energy consumption rate now
// *description* - This graph shows historical power consumption for your home, measured in watts. 
                // Here’s a breakdown of what you’re seeing:
                // The lines represent real-time power consumption.
                // The y-axis (labeled in watts) shows the magnitude of power consumption at each point in time.
                // The x-axis (time) tracks how the consumption fluctuates over the specified period.
// *units* - Watt?

// get required data
from(bucket: "telegraf")
  |> range(start: -5m)  // Last 5 minutes
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")

  |> group(columns: ["sid"])  // Group by SID to handle each SID separately
  |> last()  // Get the most recent reading for each SID

// bring each individual reading into the same table so they can be summed together
  |> group(columns: ["_measurement"])
  |> sum()
