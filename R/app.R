# The Shiny application (inst/shiny/pressR/app.R) uses DT::datatable and
# bslib::page_navbar. They are declared in Imports and referenced here so
# that R CMD check does not flag them as unused.
.shiny_imports_anchor <- function() {
  invisible(list(
    DT::datatable,
    DT::renderDT,
    bslib::page_navbar,
    bslib::bs_theme,
    bslib::nav_panel
  ))
}

#' Launch the Interactive Pressure Data Explorer
#'
#' Opens a Shiny application for importing, analyzing, and visualizing
#' pressure measurement data. The app has six tabs: Import, Heatmap,
#' Regions, Dynamics, Comparison, and Report.
#'
#' @param trial A [pr_trial] object to pre-load. If `NULL` (default),
#'   the app starts empty and the user can load data from the Import tab.
#' @param ... Additional arguments passed to [shiny::runApp()].
#'
#' @return Invisible `NULL`. Called for side effects: launches the
#'   Shiny application.
#' @export
#' @examples
#' \donttest{
#' if (interactive()) {
#'   pr_run_app(pr_example_trial("saddle_horse"))
#' }
#' }
pr_run_app <- function(trial = NULL, ...) {
  app_dir <- system.file("shiny", "pressR", package = "pressR")
  if (!nzchar(app_dir)) {
    cli::cli_abort(
      "Could not find the Shiny app directory. Try reinstalling {.pkg pressR}."
    )
  }
  if (!is.null(trial)) {
    .validate_trial(trial)
    options(pressR.preloaded_trial = trial)
    on.exit(options(pressR.preloaded_trial = NULL), add = TRUE)
  }
  shiny::runApp(app_dir, ...)
}
