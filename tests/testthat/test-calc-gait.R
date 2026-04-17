test_that("pr_calc_gait_cycles detects cycles in example data", {
  trial <- pr_example_trial("pedar")
  cycles <- pr_calc_gait_cycles(trial)
  expect_s3_class(cycles, "tbl_df")
  expect_true(nrow(cycles) >= 1L)
  expect_true(all(c("cycle", "heel_strike_frame", "toe_off_frame",
                    "stance_duration") %in% names(cycles)))
})

test_that("pr_calc_rollover returns resampled trajectory", {
  trial <- pr_example_trial("pedar")
  roll <- pr_calc_rollover(trial)
  expect_s3_class(roll, "tbl_df")
  if (nrow(roll) > 0L) {
    expect_true(max(roll$percent_stance) <= 100)
    expect_true(min(roll$percent_stance) >= 0)
  }
})
