#' Center of Pressure Object
#'
#' Construct a `pr_cop` object from x/y coordinates and time. Normally
#' created by [pr_calc_cop()] rather than called directly.
#'
#' @param x Numeric vector of COP x-coordinates (mm).
#' @param y Numeric vector of COP y-coordinates (mm).
#' @param time Numeric vector of timestamps (s).
#'
#' @return A `pr_cop` S3 object with fields `x`, `y`, `time`,
#'   `path_length`, `velocity_mean`, `velocity_max`, `range_x`, `range_y`,
#'   `sway_area`.
#' @export
pr_cop <- function(x, y, time) {
  stopifnot(
    is.numeric(x), is.numeric(y), is.numeric(time),
    length(x) == length(y), length(x) == length(time)
  )

  # Keep only valid (non-NA, non-zero-load) frames for trajectory metrics
  valid <- !is.na(x) & !is.na(y)
  xv <- x[valid]
  yv <- y[valid]
  tv <- time[valid]

  path_length <- 0
  velocity_mean <- 0
  velocity_max <- 0
  if (length(xv) >= 2L) {
    dx <- diff(xv)
    dy <- diff(yv)
    dt <- diff(tv)
    seg <- sqrt(dx^2 + dy^2)
    path_length <- sum(seg)
    vel <- ifelse(dt > 0, seg / dt, 0)
    velocity_mean <- mean(vel)
    velocity_max <- max(vel)
  }

  range_x <- if (length(xv) > 0L) diff(range(xv)) else 0
  range_y <- if (length(yv) > 0L) diff(range(yv)) else 0

  # Sway area: approximated as 95% confidence ellipse area
  sway_area <- 0
  if (length(xv) >= 3L) {
    cx <- mean(xv); cy <- mean(yv)
    vx <- stats::var(xv); vy <- stats::var(yv)
    cov_xy <- stats::cov(xv, yv)
    eig <- eigen(matrix(c(vx, cov_xy, cov_xy, vy), 2, 2), symmetric = TRUE)
    a <- sqrt(max(eig$values, 0)) * 2.4477
    b <- sqrt(max(eig$values[2], 0)) * 2.4477
    sway_area <- pi * a * b
  }

  structure(
    list(
      x = x, y = y, time = time,
      path_length = path_length,
      velocity_mean = velocity_mean,
      velocity_max = velocity_max,
      range_x = range_x,
      range_y = range_y,
      sway_area = sway_area
    ),
    class = "pr_cop"
  )
}

#' @export
print.pr_cop <- function(x, ...) {
  cli::cli_h2("pr_cop")
  cli::cli_ul(c(
    "Frames: {.val {length(x$x)}}",
    "Path length: {.val {round(x$path_length, 2)}} mm",
    "Mean velocity: {.val {round(x$velocity_mean, 2)}} mm/s",
    "Max velocity: {.val {round(x$velocity_max, 2)}} mm/s",
    "Range (x): {.val {round(x$range_x, 2)}} mm",
    "Range (y): {.val {round(x$range_y, 2)}} mm",
    "Sway area (95% ellipse): {.val {round(x$sway_area, 2)}} mm\u00b2"
  ))
  invisible(x)
}
