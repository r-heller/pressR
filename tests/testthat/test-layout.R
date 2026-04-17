test_that("pr_layout() constructs a valid object", {
  active <- matrix(TRUE, 4, 4)
  coords <- data.frame(
    sensor_id = seq_len(16),
    row = rep(1:4, each = 4),
    col = rep(1:4, times = 4),
    x_mm = rep(seq(0, 30, 10), times = 4),
    y_mm = rep(seq(0, 30, 10), each = 4)
  )
  layout <- pr_layout(4, 4, active, coords, name = "test_4x4")
  expect_s3_class(layout, "pr_layout")
  expect_equal(layout$n_sensors, 16L)
  expect_equal(layout$grid_rows, 4L)
  expect_equal(layout$grid_cols, 4L)
  expect_equal(layout$name, "test_4x4")
})

test_that("pr_layout() rejects dimension mismatches", {
  active <- matrix(TRUE, 3, 3)
  coords <- data.frame(
    sensor_id = 1:9, row = rep(1:3, each = 3),
    col = rep(1:3, 3), x_mm = 1:9, y_mm = 1:9
  )
  expect_error(pr_layout(4, 4, active, coords))
})

test_that("pr_layout() rejects sensor count mismatches", {
  active <- matrix(c(TRUE, TRUE, FALSE, TRUE), 2, 2)
  coords <- data.frame(
    sensor_id = 1:4, row = c(1, 1, 2, 2),
    col = c(1, 2, 1, 2), x_mm = 1:4, y_mm = 1:4
  )
  expect_error(pr_layout(2, 2, active, coords))
})

test_that("pr_layout() rejects misnamed region matrices", {
  active <- matrix(TRUE, 2, 2)
  coords <- data.frame(
    sensor_id = 1:4, row = c(1, 1, 2, 2),
    col = c(1, 2, 1, 2), x_mm = 1:4, y_mm = 1:4
  )
  expect_error(pr_layout(
    2, 2, active, coords,
    regions = list(list(foo = matrix(TRUE, 3, 3)))
  ))
})

test_that("print and summary for pr_layout do not error", {
  layout <- pr_layout_insole()
  expect_invisible(print(layout))
  s <- summary(layout)
  expect_s3_class(s, "summary.pr_layout")
})

test_that("pr_validate_layout accepts a valid layout", {
  expect_invisible(pr_validate_layout(pr_layout_insole()))
  expect_true(pr_validate_layout(pr_layout_saddle("horse")))
})
