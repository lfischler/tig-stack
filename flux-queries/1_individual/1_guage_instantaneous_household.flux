// *title* - Household Energy Consumption Rate (5-Minute Average)
// *description* - This panel displays the average energy consumption rate for the selected household(s) over the last 5 minutes. The data is updated in near real-time and reflects the mean of all recorded power readings during this 5-minute window. Units are displayed in kilowatts (kW)."
// *units* - Watt

// get required data
from(bucket: "telegraf")
  |> range(start: -5m)  // Last 5 minutes
  |> filter(fn: (r) => r["participant_no"] == "${p}")
  |> filter(fn: (r) => r["sid"] == "${sid1}")

  |> group(columns: ["sid"])  // Group by SID to handle each SID separately
  |> last()  // Get the most recent reading for each SID

