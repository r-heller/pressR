#' Read Pressure Data from CSV
#'
#' Reads pressure data from a CSV file in either wide (one column per
#' sensor) or long (tidy) format.
#'
#' @param path Character. Path to CSV file.
#' @param format Character. `"wide"` (default, columns are sensors) or
#'   `"long"` (a tidy format with `frame`, `sensor_id`, `pressure`).
#' @param layout A [pr_layout] object. Required for wide format when the
#'   sensor count cannot be inferred.
#' @param time_col Character. Name of the time column. If `NULL`,
#'   timestamps are generated from `sampling_hz`.
#' @param sampling_hz Numeric. Sampling rate. Default `100`.
#' @param verbose Logical. Default `TRUE`.
#'
#' @return A [pr_trial] object.
#' @export
#' @examples
#' tmp <- tempfile(fileext = ".csv")
#' m <- matrix(runif(10 * 99, 0, 100), nrow = 10, ncol = 99)
#' utils::write.csv(m, tmp, row.names = FALSE)
#' trial <- pr_read_csv(tmp, format = "wide", layout = pr_layout_insole(),
#'                      verbose = FALSE)
#' trial$n_frames
pr_read_csv <- function(path, format = c("wide", "long"), layout = NULL,
                        time_col = NULL, sampling_hz = 100,
                        verbose = TRUE) {
  if (!file.exists(path)) {
    cli::cli_abort("File not found: {.path {path}}.")
  }
  format <- match.arg(format)

  df <- readr::read_csv(path, show_col_types = FALSE, progress = FALSE)

  if (format == "wide") {
    t <- if (!is.null(time_col) && time_col %in% names(df)) {
      as.numeric(df[[time_col]])
    } else {
      NULL
    }
    if (!is.null(time_col) && time_col %in% names(df)) {
      df[[time_col]] <- NULL
    }
    # Drop any "frame" column if present (written by pr_export_csv)
    if ("frame" %in% names(df)) df[["frame"]] <- NULL
    mat <- as.matrix(df)
    if (is.null(layout)) {
      layout <- .layout_from_n_sensors(ncol(mat))
      if (is.null(layout)) {
        cli::cli_abort(
          "Could not infer layout for wide-format CSV with {ncol(mat)} columns. Pass {.arg layout}."
        )
      }
    }
    if (ncol(mat) != layout$n_sensors) {
      cli::cli_abort("CSV has {ncol(mat)} columns but layout has {layout$n_sensors} sensors.")
    }
    if (is.null(t)) {
      t <- seq(0, by = 1 / sampling_hz, length.out = nrow(mat))
    }
    if (verbose) {
      cli::cli_inform("Read {nrow(mat)} frame(s) from {.path {basename(path)}}.")
    }
    return(pr_trial(pressure = mat, time = t, layout = layout,
                    metadata = list(
                      trial_id = tools::file_path_sans_ext(basename(path))
                    ),
                    sampling_hz = sampling_hz))
  }

  # long format
  required <- c("frame", "sensor_id", "pressure")
  if (!all(required %in% names(df))) {
    cli::cli_abort(
      "Long-format CSV must contain columns: {.val {required}}."
    )
  }
  frames <- sort(unique(df$frame))
  sensors <- sort(unique(df$sensor_id))
  mat <- matrix(0, nrow = length(frames), ncol = length(sensors))
  for (i in seq_along(frames)) {
    sub <- df[df$frame == frames[i], , drop = FALSE]
    idx <- match(sub$sensor_id, sensors)
    mat[i, idx] <- sub$pressure
  }
  if (is.null(layout)) {
    layout <- .layout_from_n_sensors(ncol(mat))
    if (is.null(layout)) {
      cli::cli_abort(
        "Could not infer layout for long-format data ({ncol(mat)} sensors)."
      )
    }
  }
  if (!is.null(time_col) && time_col %in% names(df)) {
    t <- vapply(frames, function(f) {
      df[[time_col]][which(df$frame == f)[1]]
    }, numeric(1))
  } else {
    t <- seq(0, by = 1 / sampling_hz, length.out = length(frames))
  }
  pr_trial(pressure = mat, time = t, layout = layout,
           metadata = list(
             trial_id = tools::file_path_sans_ext(basename(path))
           ),
           sampling_hz = sampling_hz)
}
