test_that("pr_calc_saddle_bridge returns expected structure", {
  trial <- pr_example_trial("saddle_horse")
  res <- pr_calc_saddle_bridge(trial)
  expect_s3_class(res, "pr_saddle_bridge")
  expect_type(res$bridge_ratio, "double")
  expect_type(res$is_bridged, "logical")
  expect_s3_class(res$regional_pressures, "tbl_df")
  expect_true(nchar(res$recommendation) > 10)
})

test_that("pr_calc_saddle_slip computes symmetry index", {
  trial <- pr_example_trial("saddle_horse")
  res <- pr_calc_saddle_slip(trial)
  expect_s3_class(res, "pr_saddle_slip")
  expect_true(res$dominant_side %in% c("left", "right", "balanced"))
  expect_length(res$si_timeseries, trial$n_frames)
})

test_that("pr_calc_seat_hotspot returns tibble", {
  trial <- pr_example_trial("wheelchair")
  hs <- pr_calc_seat_hotspot(trial, threshold = 1)
  expect_s3_class(hs, "tbl_df")
  expect_true(all(c("sensor_id", "max_pressure") %in% names(hs)))
})
