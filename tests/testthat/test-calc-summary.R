test_that("pr_summary returns a one-row tibble with expected columns", {
  trial <- pr_example_trial("pedar")
  s <- pr_summary(trial)
  expect_s3_class(s, "tbl_df")
  expect_equal(nrow(s), 1L)
  expect_true(all(c("mpp", "mvp", "max_force", "mean_force",
                    "max_contact_area", "mean_contact_area",
                    "contact_time", "pti_max", "pti_mean", "impulse",
                    "cop_path_length", "cop_velocity_mean",
                    "cop_range_ap", "cop_range_ml") %in% names(s)))
  expect_true(s$mpp > 0)
})

test_that("pr_calc_symmetry_index returns numeric", {
  si <- pr_calc_symmetry_index(pr_example_trial("saddle_horse"))
  expect_type(si, "double")
  expect_true(is.finite(si))
})

test_that("pr_calc_regional returns one row per region", {
  trial <- pr_example_trial("saddle_horse")
  r <- pr_calc_regional(trial)
  expect_s3_class(r, "tbl_df")
  expect_equal(nrow(r), 6L)
  expect_true("mpp" %in% names(r))
})
