#' Regional Parameter Comparison Bar Chart
#'
#' @param regional_data Output of [pr_calc_regional()].
#' @param parameter Character. Parameter column to plot. Default `"mpp"`.
#' @param thresholds A [tibble::tibble] from `pr_ref_*()` functions.
#'   If non-`NULL`, draws horizontal threshold lines where `parameter`
#'   matches.
#'
#' @return A `ggplot2` object.
#' @export
#' @examples
#' trial <- pr_example_trial("saddle_horse")
#' reg <- pr_calc_regional(trial)
#' pr_plot_regional_bar(reg, "mpp")
pr_plot_regional_bar <- function(regional_data, parameter = "mpp",
                                 thresholds = NULL) {
  if (!is.data.frame(regional_data)) {
    cli::cli_abort("{.arg regional_data} must be a data frame.")
  }
  if (!parameter %in% names(regional_data)) {
    cli::cli_abort("Parameter {.val {parameter}} not found in {.arg regional_data}.")
  }

  df <- regional_data
  df$value <- df[[parameter]]

  p <- ggplot2::ggplot(df,
         ggplot2::aes(x = stats::reorder(.data$region, -.data$value),
                      y = .data$value)) +
    ggplot2::geom_col(fill = "#00897B", colour = "#1A2332",
                      linewidth = 0.3) +
    ggplot2::labs(
      x = "Region", y = parameter,
      title = sprintf("Regional %s", parameter)
    ) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))

  if (!is.null(thresholds) && is.data.frame(thresholds) &&
      "parameter" %in% names(thresholds) &&
      "threshold" %in% names(thresholds)) {
    t_sub <- thresholds[thresholds$parameter == parameter, , drop = FALSE]
    if (nrow(t_sub) > 0L) {
      for (i in seq_len(nrow(t_sub))) {
        p <- p + ggplot2::geom_hline(
          yintercept = t_sub$threshold[i], linetype = "dashed",
          colour = "#C21D1D"
        )
      }
    }
  }
  p
}

#' Left/Right Symmetry Plot
#'
#' @param trial A [pr_trial] object.
#' @param parameter Character. One of `"peak_pressure"`, `"mean_pressure"`,
#'   `"force"`, `"contact_area"`.
#' @return A `ggplot2` object with a mirrored bar chart.
#' @export
#' @examples
#' pr_plot_symmetry(pr_example_trial("saddle_horse"))
pr_plot_symmetry <- function(trial,
                             parameter = c("peak_pressure",
                                           "mean_pressure",
                                           "force",
                                           "contact_area")) {
  .validate_trial(trial)
  parameter <- match.arg(parameter)
  masks <- pr_mask_symmetry(trial$layout, axis = "vertical")
  reg <- pr_mask_apply(trial, masks)

  compute <- function(M) {
    if (ncol(M) == 0L) return(0)
    switch(
      parameter,
      peak_pressure = max(M, na.rm = TRUE),
      mean_pressure = mean(M[M > 0], na.rm = TRUE),
      force         = mean(rowSums(M)) * trial$layout$sensor_area_cm2 * 0.1,
      contact_area  = mean(rowSums(M > 0)) * trial$layout$sensor_area_cm2
    )
  }
  L <- compute(reg$left)
  R <- compute(reg$right)
  df <- tibble::tibble(
    side = c("Left", "Right"),
    value = c(L, R)
  )
  si <- if ((L + R) > 0) (L - R) / (0.5 * (L + R)) * 100 else 0

  ggplot2::ggplot(df, ggplot2::aes(.data$side, .data$value, fill = .data$side)) +
    ggplot2::geom_col(width = 0.5, colour = "#1A2332", linewidth = 0.3) +
    ggplot2::scale_fill_manual(values = c(Left = "#00897B", Right = "#26A69A"),
                               guide = "none") +
    ggplot2::labs(
      title = sprintf("Symmetry (%s)", parameter),
      subtitle = sprintf("SI = %.2f%%", si),
      x = NULL, y = parameter
    ) +
    ggplot2::theme_minimal(base_size = 11)
}

#' Compare Two Trials
#'
#' Produces a side-by-side heatmap comparison, a difference map, or a
#' parameter-table plot for two trials.
#'
#' @param trial_a A [pr_trial] object. Reference.
#' @param trial_b A [pr_trial] object. Comparison.
#' @param type Character. `"heatmap"` (default), `"difference"`, or
#'   `"parameters"`.
#' @param labels Character vector of length 2. Default `c("A", "B")`.
#'
#' @return A `ggplot2` (or patchwork) object.
#' @export
#' @examples
#' a <- pr_example_trial("insole", seed = 1)
#' b <- pr_example_trial("insole", seed = 2)
#' pr_plot_comparison(a, b, type = "difference")
pr_plot_comparison <- function(trial_a, trial_b,
                               type = c("heatmap", "difference",
                                        "parameters"),
                               labels = c("A", "B")) {
  .validate_trial(trial_a)
  .validate_trial(trial_b)
  type <- match.arg(type)
  if (type == "heatmap") {
    pa <- pr_plot_heatmap(trial_a, title = labels[1])
    pb <- pr_plot_heatmap(trial_b, title = labels[2])
    return(patchwork::wrap_plots(pa, pb, ncol = 2))
  }
  if (type == "difference") {
    if (trial_a$layout$name != trial_b$layout$name ||
        trial_a$n_sensors != trial_b$n_sensors) {
      cli::cli_abort(
        "Difference maps require trials with matching layouts."
      )
    }
    a_mpp <- apply(trial_a$pressure, 2, max)
    b_mpp <- apply(trial_b$pressure, 2, max)
    df <- .heatmap_tibble(trial_a$layout, b_mpp - a_mpp)
    tile_w <- sqrt(trial_a$layout$sensor_area_cm2) * 10
    return(
      ggplot2::ggplot(df,
          ggplot2::aes(.data$x_mm, .data$y_mm, fill = .data$value)) +
        ggplot2::geom_tile(width = tile_w, height = tile_w) +
        ggplot2::scale_fill_gradient2(
          low = "#1F78B4", mid = "white", high = "#C21D1D", midpoint = 0,
          name = sprintf("%s - %s (%s)", labels[2], labels[1],
                         trial_a$layout$pressure_unit)
        ) +
        ggplot2::coord_fixed() +
        ggplot2::labs(title = "Difference map (MPP)",
                      x = "x (mm)", y = "y (mm)") +
        ggplot2::theme_minimal(base_size = 11)
    )
  }
  # parameters: side-by-side bar chart of trial summaries
  sa <- pr_summary(trial_a); sa$trial <- labels[1]
  sb <- pr_summary(trial_b); sb$trial <- labels[2]
  both <- rbind(sa, sb)
  long <- tidyr::pivot_longer(
    both, cols = setdiff(names(both), "trial"),
    names_to = "parameter", values_to = "value"
  )
  ggplot2::ggplot(long,
      ggplot2::aes(.data$parameter, .data$value, fill = .data$trial)) +
    ggplot2::geom_col(position = ggplot2::position_dodge(width = 0.8),
                      width = 0.7, colour = "#1A2332", linewidth = 0.3) +
    ggplot2::scale_fill_manual(
      values = stats::setNames(c("#00897B", "#26A69A"), labels)
    ) +
    ggplot2::labs(title = "Parameter comparison",
                  x = NULL, y = "Value", fill = NULL) +
    ggplot2::theme_minimal(base_size = 11) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 30, hjust = 1))
}
