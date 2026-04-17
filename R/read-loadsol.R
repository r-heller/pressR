#' Read loadsol Force Data
#'
#' Parses a CSV exported from novel's loadsol app. The loadsol system
#' records a small number of force zones (not a full pressure matrix);
#' this parser returns a simplified [pr_trial] where each "sensor" is a
#' force zone. Pressure values are reported in Newtons.
#'
#' @param path Character. Path to the CSV file.
#' @param force_cols Character vector. Names of force columns. If `NULL`,
#'   all numeric columns other than the first (time) column are used.
#' @param time_col Character. Name of the time column. Default `"time"`.
#' @param verbose Logical. Default `TRUE`.
#'
#' @return A [pr_trial] object with a minimal single-row layout
#'   (one sensor per force zone).
#' @export
#' @examples
#' tmp <- tempfile(fileext = ".csv")
#' df <- data.frame(time = seq(0, 1, by = 0.01),
#'                  heel = runif(101, 0, 200),
#'                  mid  = runif(101, 0, 150),
#'                  fore = runif(101, 0, 300))
#' utils::write.csv(df, tmp, row.names = FALSE)
#' trial <- pr_read_loadsol(tmp, verbose = FALSE)
#' trial$n_sensors
pr_read_loadsol <- function(path, force_cols = NULL, time_col = "time",
                            verbose = TRUE) {
  if (!file.exists(path)) {
    cli::cli_abort("File not found: {.path {path}}.")
  }
  df <- readr::read_csv(path, show_col_types = FALSE, progress = FALSE)

  if (!time_col %in% names(df)) {
    cli::cli_abort("Time column {.val {time_col}} not found.")
  }
  t <- as.numeric(df[[time_col]])

  if (is.null(force_cols)) {
    force_cols <- setdiff(names(df), time_col)
  }
  missing <- setdiff(force_cols, names(df))
  if (length(missing) > 0L) {
    cli::cli_abort("Force column(s) not found: {.val {missing}}.")
  }
  mat <- as.matrix(df[, force_cols, drop = FALSE])
  storage.mode(mat) <- "double"

  n_zones <- ncol(mat)
  # Construct a 1 x n_zones "layout"
  active <- matrix(TRUE, 1L, n_zones)
  coords <- tibble::tibble(
    sensor_id = seq_len(n_zones),
    row = rep(1L, n_zones),
    col = seq_len(n_zones),
    x_mm = (seq_len(n_zones) - 1) * 50,
    y_mm = rep(0, n_zones)
  )
  layout <- pr_layout(
    grid_rows = 1L, grid_cols = n_zones,
    active = active, coords_mm = coords,
    sensor_area_cm2 = 1,
    pressure_range = c(0, max(mat, na.rm = TRUE)),
    pressure_unit = "N",
    name = "loadsol",
    description = "loadsol force zones (one sensor per zone).",
    manufacturer = "novel GmbH",
    model = "loadsol"
  )

  dt <- if (length(t) >= 2L) mean(diff(t)) else 1 / 50
  hz <- 1 / dt

  if (verbose) {
    cli::cli_inform("Read loadsol file with {n_zones} zone(s), {nrow(mat)} frame(s).")
  }
  pr_trial(
    pressure = mat, time = t, layout = layout,
    metadata = list(
      trial_id = tools::file_path_sans_ext(basename(path)),
      system = "loadsol",
      zones = paste(force_cols, collapse = ",")
    ),
    sampling_hz = hz
  )
}
