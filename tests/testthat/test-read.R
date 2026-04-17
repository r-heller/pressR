test_that("pr_read_ascii parses example file", {
  path <- pr_example_files("pedar")
  trial <- pr_read_ascii(path, verbose = FALSE)
  expect_s3_class(trial, "pr_trial")
  expect_equal(trial$layout$n_sensors, 99L)
  expect_true(trial$n_frames > 0L)
})

test_that("pr_read_ascii errors on missing file", {
  expect_error(pr_read_ascii("/nonexistent/file.asc"))
})

test_that("pr_read_auto dispatches on extension", {
  path <- pr_example_files("pedar")
  trial <- pr_read_auto(path, verbose = FALSE)
  expect_s3_class(trial, "pr_trial")
})

test_that("pr_read_csv round-trips wide pressure data", {
  trial <- pr_example_trial("pedar")
  tmp <- withr::local_tempfile(fileext = ".csv")
  pr_export_csv(trial, tmp, what = "pressure")
  trial2 <- pr_read_csv(tmp, format = "wide",
                        layout = pr_layout_pedar(),
                        time_col = "time", verbose = FALSE)
  expect_s3_class(trial2, "pr_trial")
  expect_equal(trial2$n_frames, trial$n_frames)
})

test_that("pr_read_mask parses simple mask text", {
  tmp <- withr::local_tempfile(fileext = ".msa")
  writeLines(c("1 0", "0 1"), tmp)
  m <- pr_read_mask(tmp, verbose = FALSE)
  expect_true(is.logical(m))
  expect_equal(dim(m), c(2L, 2L))
})

test_that("pr_read_loadsol parses basic CSV", {
  tmp <- withr::local_tempfile(fileext = ".csv")
  utils::write.csv(
    data.frame(
      time = seq(0, 1, by = 0.01),
      heel = runif(101, 0, 200),
      fore = runif(101, 0, 300)
    ),
    tmp, row.names = FALSE
  )
  trial <- pr_read_loadsol(tmp, verbose = FALSE)
  expect_s3_class(trial, "pr_trial")
  expect_equal(trial$n_sensors, 2L)
})
