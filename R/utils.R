#' Spatial Interpolation of Pressure Data (for Display)
#'
#' Performs bilinear interpolation on the maximum pressure picture
#' between active sensor positions to produce a smoother image. The
#' underlying trial data is not modified.
#'
#' @param trial A [pr_trial] object.
#' @param factor Integer. Interpolation factor in each dimension.
#'   Default `2`.
#'
#' @return A list with `pressure_interp` (interpolated matrix),
#'   `x_mm`, `y_mm`.
#' @export
#' @examples
#' out <- pr_interpolate(pr_example_trial("pedar"), factor = 2)
#' dim(out$pressure_interp)
pr_interpolate <- function(trial, factor = 2L) {
  .validate_trial(trial)
  factor <- as.integer(factor)
  if (factor < 1L) cli::cli_abort("{.arg factor} must be a positive integer.")

  layout <- trial$layout
  mpp <- apply(trial$pressure, 2, max)
  grid <- matrix(0, layout$grid_rows, layout$grid_cols)
  active_idx <- which(layout$active)
  grid[active_idx] <- mpp

  # Bilinear interpolation using stats::approx on rows then cols
  if (factor == 1L) {
    return(list(
      pressure_interp = grid,
      x_mm = seq_len(ncol(grid)),
      y_mm = seq_len(nrow(grid))
    ))
  }
  nr <- nrow(grid)
  nc <- ncol(grid)
  nr_new <- (nr - 1) * factor + 1
  nc_new <- (nc - 1) * factor + 1
  # Interpolate each row along columns
  mid <- t(apply(grid, 1, function(r) {
    stats::approx(seq_len(nc), r, n = nc_new)$y
  }))
  # Interpolate each column along rows
  out <- apply(mid, 2, function(c) {
    stats::approx(seq_len(nr), c, n = nr_new)$y
  })

  list(
    pressure_interp = out,
    x_mm = seq(1, nc, length.out = nc_new),
    y_mm = seq(1, nr, length.out = nr_new)
  )
}

#' Subset a Trial to a Time Window
#'
#' @param trial A [pr_trial] object.
#' @param from Numeric. Start time (s). Default `0`.
#' @param to Numeric. End time (s). Default `Inf`.
#'
#' @return A [pr_trial] containing only frames with `time` in `[from, to]`.
#' @export
#' @examples
#' tr <- pr_filter_time(pr_example_trial("pedar"), from = 1, to = 3)
#' tr$duration
pr_filter_time <- function(trial, from = 0, to = Inf) {
  .validate_trial(trial)
  keep <- trial$time >= from & trial$time <= to
  if (!any(keep)) {
    cli::cli_abort("No frames in the requested time window.")
  }
  pr_trial(
    pressure = trial$pressure[keep, , drop = FALSE],
    time = trial$time[keep],
    layout = trial$layout,
    metadata = trial$metadata,
    sampling_hz = trial$sampling_hz
  )
}

#' Downsample a Trial
#'
#' Keeps every `factor`-th frame.
#'
#' @param trial A [pr_trial] object.
#' @param factor Integer. Downsample factor. Default `2`.
#'
#' @return A [pr_trial] object with reduced frame count.
#' @export
#' @examples
#' tr <- pr_downsample(pr_example_trial("pedar"), factor = 2)
#' tr$n_frames
pr_downsample <- function(trial, factor = 2L) {
  .validate_trial(trial)
  factor <- as.integer(factor)
  if (factor < 1L) cli::cli_abort("{.arg factor} must be a positive integer.")
  if (factor == 1L) return(trial)
  idx <- seq(1L, trial$n_frames, by = factor)
  pr_trial(
    pressure = trial$pressure[idx, , drop = FALSE],
    time = trial$time[idx],
    layout = trial$layout,
    metadata = trial$metadata,
    sampling_hz = trial$sampling_hz / factor
  )
}
