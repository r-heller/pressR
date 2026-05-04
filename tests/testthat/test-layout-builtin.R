test_that("pr_layout_insole() returns a valid layout", {
  layout <- pr_layout_insole()
  expect_s3_class(layout, "pr_layout")
  expect_equal(layout$n_sensors, 99L)
  expect_true(length(layout$regions) >= 5L)
})

test_that("pr_layout_insole('wide') has same sensor count", {
  layout <- pr_layout_insole("wide")
  expect_equal(layout$n_sensors, 99L)
})

test_that("pr_layout_platform() exposes expected grid sizes", {
  expect_equal(pr_layout_platform("st")$grid_rows, 64L)
  expect_equal(pr_layout_platform("xl")$grid_rows, 96L)
  expect_equal(pr_layout_platform("cl")$grid_rows, 48L)
})

test_that("pr_layout_mat() returns full grid layouts", {
  expect_equal(pr_layout_mat("16")$n_sensors, 256L)
  expect_equal(pr_layout_mat("32")$n_sensors, 1024L)
})

test_that("pr_layout_saddle('horse') has 6 named regions", {
  layout <- pr_layout_saddle("horse")
  expect_equal(length(layout$regions), 6L)
  expect_true(all(c("cranial_left", "cranial_right",
                    "middle_left", "middle_right",
                    "caudal_left", "caudal_right")
                  %in% names(layout$regions)))
})

test_that("pr_layout_saddle('bicycle') has named regions", {
  layout <- pr_layout_saddle("bicycle")
  expect_true("left_ischial" %in% names(layout$regions))
  expect_true("right_ischial" %in% names(layout$regions))
})

test_that("pr_layout_seat() returns 32x32 grid", {
  layout <- pr_layout_seat("wheelchair")
  expect_equal(layout$grid_rows, 32L)
  expect_equal(layout$grid_cols, 32L)
  expect_true(length(layout$regions) >= 3L)
})

test_that("pr_layout_glove() returns 32 sensors", {
  layout <- pr_layout_glove()
  expect_equal(layout$n_sensors, 32L)
})

test_that("pr_layout_list() returns a tibble of all layouts", {
  lst <- pr_layout_list()
  expect_s3_class(lst, "tbl_df")
  expect_true(nrow(lst) >= 10L)
  expect_true(all(c("name", "system", "grid_rows", "grid_cols",
                    "n_sensors", "n_regions", "description")
                  %in% names(lst)))
})
