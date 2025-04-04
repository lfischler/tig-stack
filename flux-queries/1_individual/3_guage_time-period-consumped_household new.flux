// *title* - Power Consumption during Timeperiod
// *description* - This gauge shows the total energy consumption (in kilowatt-hours) within your household for the selected time window. The value reflects the cumulative energy used over the specified time range, providing a clear and immediate indication of your total power consumption. By adjusting the time range, you can track your household's overall energy usage and monitor your consumption trends.
// *Units*: kWh

// get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "PWER")
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["participant_no"] == "${p}")
  |> filter(fn: (r) => r["sid"] == "${sid1}")

 // Convert values to float and calculate energy in kWh based on fact reading is taken every 10s
  |> map(fn: (r) => ({
      r with
      energy_kwh: (float(v: r._value) * (10.0 / 3600.0)) / 1000.0
  }))

  |> sum(column: "energy_kwh") // Total energy in Wh for the range
  
  |> yield(name: "Total Energy Consumption")
