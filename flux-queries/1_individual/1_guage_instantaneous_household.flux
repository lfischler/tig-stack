// get required data
from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_field"] == "value")
  |> filter(fn: (r) => r["participant_no"] == "P1")
  |> filter(fn: (r) => r["sid"] == "818129" or r["sid"] == "823963")

  last()


// This one was incorrect because it was doing the mean of the window period
// (which may have been quite a good resolution but we don't know)