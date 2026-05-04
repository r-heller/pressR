#' Auto-Detect and Read a Pressure Data File
#'
#' Inspects the file extension and header, then dispatches to the correct
#' parser.
#'
#' @param path Character. Path to any supported pressure data file.
#' @param layout A [pr_layout] object. If `NULL`, inferred by the
#'   dispatched parser.
#' @param verbose Logical. Default `TRUE`.
#'
#' @return A [pr_trial] object (for `.asc` / `.txt` / `.csv`), or a
#'   logical mask matrix / [pr_mask] object (for `.msa`/`.msr`/`.msp`).
#' @export
#' @examples
#' path <- pr_example_files("insole")
#' tr <- pr_read_auto(path, verbose = FALSE)
#' inherits(tr, "pr_trial")
pr_read_auto <- function(path, layout = NULL, verbose = TRUE) {
  if (!file.exists(path)) {
    cli::cli_abort("File not found: {.path {path}}.")
  }
  ext <- tolower(tools::file_ext(path))
  switch(
    ext,
    asc = pr_read_ascii(path, layout = layout, verbose = verbose),
    txt = pr_read_ascii(path, layout = layout, verbose = verbose),
    csv = pr_read_csv(path, layout = layout, verbose = verbose),
    msa = pr_read_mask(path, layout = layout, verbose = verbose),
    msr = pr_read_mask(path, layout = layout, verbose = verbose),
    msp = pr_read_mask(path, layout = layout, verbose = verbose),
    cli::cli_abort("Unsupported file extension: {.val {ext}}.")
  )
}
