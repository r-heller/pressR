test_that("pr_calc_peak_pressure returns valid values", {
  trial <- pr_example_trial("pedar")
  pp <- pr_calc_peak_pressure(trial)
  expect_type(pp, "double")
  expect_length(pp, trial$n_frames)
  expect_true(all(pp >= 0))
})

test_that("pr_calc_force uses correct unit conversion", {
  layout <- pr_layout(
    grid_rows = 2, grid_cols = 2,
    active = matrix(TRUE, 2, 2),
    coords_mm = data.frame(
      sensor_id = 1:4, row = c(1, 1, 2, 2),
      col = c(1, 2, 1, 2),
      x_mm = c(0, 10, 0, 10), y_mm = c(0, 0, 10, 10)
    ),
    sensor_area_cm2 = 1
  )
  trial <- pr_trial(
    pressure = matrix(100, nrow = 1, ncol = 4),
    time = 0, layout = layout
  )
  # Force = 100 kPa * 1 cm^2 * 4 * 0.1 = 40 N
  expect_equal(pr_calc_force(trial), 40)
})

test_that("pr_calc_contact_area counts loaded sensors", {
  layout <- pr_layout_pliance("16")
  P <- matrix(0, nrow = 3, ncol = layout$n_sensors)
  P[1, 1:10] <- 50
  P[2, 1:100] <- 50
  trial <- pr_trial(P, time = c(0, 0.01, 0.02), layout = layout)
  ca <- pr_calc_contact_area(trial)
  expect_equal(ca[1], 10 * layout$sensor_area_cm2)
  expect_equal(ca[2], 100 * layout$sensor_area_cm2)
  expect_equal(ca[3], 0)
})

test_that("pr_calc_cop returns a pr_cop object", {
  trial <- pr_example_trial("saddle_horse")
  cop <- pr_calc_cop(trial)
  expect_s3_class(cop, "pr_cop")
  expect_length(cop$x, trial$n_frames)
  expect_true(is.numeric(cop$path_length))
})

test_that("pr_calc_cop returns NA when no load", {
  layout <- pr_layout_pliance("16")
  trial <- pr_trial(
    pressure = matrix(0, nrow = 3, ncol = layout$n_sensors),
    time = c(0, 0.01, 0.02), layout = layout
  )
  cop <- pr_calc_cop(trial)
  expect_true(all(is.na(cop$x)))
})

test_that("pr_calc_pti is non-negative", {
  trial <- pr_example_trial("pedar")
  pti <- pr_calc_pti(trial)
  expect_true(all(pti >= 0))
})
