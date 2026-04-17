test_that("pr_export_csv writes summary", {
  trial <- pr_example_trial("insole")
  tmp <- withr::local_tempfile(fileext = ".csv")
  pr_export_csv(trial, tmp, what = "summary")
  expect_true(file.exists(tmp))
  re <- readr::read_csv(tmp, show_col_types = FALSE)
  expect_true("mpp" %in% names(re))
})

test_that("pr_export_csv writes regional", {
  trial <- pr_example_trial("saddle_horse")
  tmp <- withr::local_tempfile(fileext = ".csv")
  pr_export_csv(trial, tmp, what = "regional")
  expect_true(file.exists(tmp))
})

test_that("pr_export_csv writes cop", {
  trial <- pr_example_trial("insole")
  tmp <- withr::local_tempfile(fileext = ".csv")
  pr_export_csv(trial, tmp, what = "cop")
  expect_true(file.exists(tmp))
})

test_that("pr_batch_summary combines multiple trials", {
  ds <- pr_dataset(list(
    pr_example_trial("insole", seed = 1),
    pr_example_trial("insole", seed = 2)
  ))
  s <- pr_batch_summary(ds)
  expect_s3_class(s, "tbl_df")
  expect_equal(nrow(s), 2L)
})
