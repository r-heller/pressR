test_that("pr_filter_time subsets the trial", {
  trial <- pr_example_trial("insole")
  f <- pr_filter_time(trial, from = 1, to = 3)
  expect_s3_class(f, "pr_trial")
  expect_true(all(f$time >= 1 & f$time <= 3))
})

test_that("pr_downsample reduces frame count", {
  trial <- pr_example_trial("insole")
  d <- pr_downsample(trial, 2)
  expect_true(d$n_frames < trial$n_frames)
})

test_that("pr_interpolate expands grid size", {
  trial <- pr_example_trial("insole")
  out <- pr_interpolate(trial, factor = 2)
  expect_true(dim(out$pressure_interp)[1] > trial$layout$grid_rows)
})

test_that("reference threshold tibbles have required columns", {
  sd <- pr_ref_saddle()
  expect_true(all(c("region", "parameter", "threshold", "unit", "source")
                  %in% names(sd)))
  df <- pr_ref_diabetic_foot()
  expect_s3_class(df, "tbl_df")
  wc <- pr_ref_wheelchair()
  expect_s3_class(wc, "tbl_df")
})
