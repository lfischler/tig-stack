// Get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")

// display the mean of every grouping (reduces number of measurements)
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)

// display that mean
  |> yield(name: "mean")

  // NOTES
  // this creates the mean of the grouped values.
  // So you always get just one instananeous value per datapoint.