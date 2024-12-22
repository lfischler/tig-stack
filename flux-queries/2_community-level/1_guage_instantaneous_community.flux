// Gets the data from the telegraf bucket and records it in the correct columns
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "819206" or r["sid"] == "823963" or r["sid"] == "831112" or r["sid"] == "847844")
  |> drop(columns: ["host", "_field", "_measurement"])

  |> window(every: 1m)
  |> drop(columns: ["_time"])
  |> duplicate(column: "_stop", as: "_time")

  |> group(columns: ["_time"])
  |> sum(column: "_value")

  |> group()