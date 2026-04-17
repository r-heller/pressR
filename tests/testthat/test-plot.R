test_that("pr_plot_heatmap returns a ggplot", {
  trial <- pr_example_trial("pedar")
  p <- pr_plot_heatmap(trial)
  expect_s3_class(p, "ggplot")
})

test_that("pr_plot_heatmap works with frame argument", {
  trial <- pr_example_trial("pedar")
  p <- pr_plot_heatmap(trial, frame = 1)
  expect_s3_class(p, "ggplot")
})

test_that("pr_plot_heatmap supports all documented palettes", {
  trial <- pr_example_trial("custom")
  for (pal in c("viridis", "inferno", "plasma", "magma", "jet", "novel")) {
    p <- pr_plot_heatmap(trial, palette = pal)
    expect_s3_class(p, "ggplot")
  }
})

test_that("pr_plot_heatmap_masked overlays regions", {
  trial <- pr_example_trial("saddle_horse")
  p <- pr_plot_heatmap_masked(trial)
  expect_s3_class(p, "ggplot")
})

test_that("dynamics plots return ggplot", {
  trial <- pr_example_trial("pedar")
  expect_s3_class(pr_plot_force_time(trial), "ggplot")
  expect_s3_class(pr_plot_pressure_time(trial), "ggplot")
  expect_s3_class(pr_plot_cop(trial), "ggplot")
  expect_s3_class(pr_plot_contact_area(trial), "ggplot")
})

test_that("regional plots return ggplot", {
  trial <- pr_example_trial("saddle_horse")
  r <- pr_calc_regional(trial)
  expect_s3_class(pr_plot_regional_bar(r, "mpp"), "ggplot")
  expect_s3_class(pr_plot_symmetry(trial), "ggplot")
})

test_that("composite saddle report builds", {
  trial <- pr_example_trial("saddle_horse")
  p <- pr_plot_saddle_report(trial)
  expect_true(inherits(p, c("patchwork", "ggplot")))
})

test_that("pr_plot_comparison builds all types", {
  a <- pr_example_trial("pedar", seed = 1)
  b <- pr_example_trial("pedar", seed = 2)
  expect_true(inherits(pr_plot_comparison(a, b, "heatmap"),
                        c("patchwork", "ggplot")))
  expect_s3_class(pr_plot_comparison(a, b, "difference"), "ggplot")
  expect_s3_class(pr_plot_comparison(a, b, "parameters"), "ggplot")
})
