# ---------------------------------------------------------------------------
# Export / reporting.
# ---------------------------------------------------------------------------

#' Export Analysis Results to CSV
#'
#' @param trial A [pr_trial] object.
#' @param path Character. Output file path.
#' @param what Character. `"summary"` (default), `"regional"`,
#'   `"pressure"`, or `"cop"`.
#' @param masks Named list of masks. Required for `what = "regional"`.
#'
#' @return Invisibly returns the written file path.
#' @export
#' @examples
#' tmp <- tempfile(fileext = ".csv")
#' pr_export_csv(pr_example_trial("pedar"), tmp, what = "summary")
pr_export_csv <- function(trial, path,
                          what = c("summary", "regional", "pressure", "cop"),
                          masks = NULL) {
  .validate_trial(trial)
  what <- match.arg(what)

  out <- switch(
    what,
    summary = pr_summary(trial),
    regional = pr_calc_regional(trial, masks %||% NULL),
    pressure = {
      coords <- trial$layout$coords_mm
      df <- as.data.frame(trial$pressure)
      names(df) <- sprintf("s%d", coords$sensor_id)
      df$frame <- seq_len(trial$n_frames)
      df$time <- trial$time
      df[, c("frame", "time", setdiff(names(df), c("frame", "time")))]
    },
    cop = {
      cop <- pr_calc_cop(trial)
      tibble::tibble(frame = seq_len(trial$n_frames), time = trial$time,
                     x_mm = cop$x, y_mm = cop$y)
    }
  )
  utils::write.csv(out, path, row.names = FALSE)
  invisible(path)
}

#' Generate an Analysis Report
#'
#' Renders a parameterized R Markdown template into an HTML or PDF report
#' for a trial.
#'
#' @param trial A [pr_trial] object.
#' @param output_file Character. Output file path.
#' @param format Character. `"html"` (default) or `"pdf"`.
#' @param template Character. `"generic"` (default), `"saddle"`, or
#'   `"foot"`.
#' @param masks Named list of masks. `NULL` uses the layout defaults.
#' @param thresholds Optional reference threshold tibble.
#'
#' @return Invisibly returns the generated file path.
#' @export
#' @examples
#' \dontrun{
#' tmp <- tempfile(fileext = ".html")
#' pr_export_report(pr_example_trial("pedar"), tmp, template = "foot")
#' }
pr_export_report <- function(trial, output_file,
                             format = c("html", "pdf"),
                             template = c("generic", "saddle", "foot"),
                             masks = NULL, thresholds = NULL) {
  .validate_trial(trial)
  format <- match.arg(format)
  template <- match.arg(template)
  if (!requireNamespace("rmarkdown", quietly = TRUE)) {
    cli::cli_abort(
      "Package {.pkg rmarkdown} is required to generate reports."
    )
  }
  rmd <- system.file("templates",
                     sprintf("report_%s.Rmd", template),
                     package = "pressR")
  if (!nzchar(rmd)) {
    cli::cli_abort("Template not found: {.val {template}}.")
  }
  out_fmt <- if (format == "html") "html_document" else "pdf_document"
  rmarkdown::render(
    rmd,
    output_file = output_file,
    output_format = out_fmt,
    params = list(
      trial = trial,
      masks = masks,
      thresholds = thresholds
    ),
    envir = new.env(parent = globalenv()),
    quiet = TRUE
  )
  invisible(output_file)
}
