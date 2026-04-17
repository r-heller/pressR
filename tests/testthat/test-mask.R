test_that("pr_mask constructs valid mask", {
  layout <- pr_layout_saddle("horse")
  m <- pr_mask(layout$regions$cranial_left, "cranial_left", layout)
  expect_s3_class(m, "pr_mask")
  expect_true(m$n_sensors > 0L)
})

test_that("pr_mask_default returns layout's regions", {
  masks <- pr_mask_default(pr_layout_saddle("horse"))
  expect_length(masks, 6L)
})

test_that("pr_mask_apply extracts correct column counts", {
  trial <- pr_example_trial("saddle_horse")
  parts <- pr_mask_apply(trial)
  expect_length(parts, 6L)
  expect_true(all(vapply(parts, ncol, integer(1)) > 0L))
})

test_that("pr_mask_symmetry returns two named masks", {
  sym <- pr_mask_symmetry(pr_layout_saddle("horse"), "vertical")
  expect_named(sym, c("left", "right"))
  expect_s3_class(sym$left, "pr_mask")
})

test_that("pr_mask_saddle_6 returns six named masks", {
  m <- pr_mask_saddle_6(pr_layout_saddle("horse"))
  expect_named(m, c("cranial_left", "cranial_right",
                    "middle_left", "middle_right",
                    "caudal_left", "caudal_right"))
})

test_that("pr_mask_foot_auto handles empty pressure gracefully", {
  layout <- pr_layout_platform("cl")
  trial <- pr_trial(
    pressure = matrix(0, nrow = 5, ncol = layout$n_sensors),
    time = seq(0, 0.1, length.out = 5), layout = layout
  )
  expect_warning(res <- pr_mask_foot_auto(trial))
  expect_length(res, 0L)
})
