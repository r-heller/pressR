#' Create a Pressure Dataset
#'
#' A `pr_dataset` is a collection of [pr_trial] objects with shared
#' grouping metadata, intended for batch analysis.
#'
#' @param trials A list of [pr_trial] objects.
#' @param group_var Character. Name of the metadata field to use as the
#'   grouping variable. Default `"condition"`.
#' @param name Character. Name of the dataset. Default `"dataset"`.
#'
#' @return A `pr_dataset` S3 object.
#' @export
#' @examples
#' t1 <- pr_example_trial("pedar", seed = 1)
#' t2 <- pr_example_trial("pedar", seed = 2)
#' ds <- pr_dataset(list(t1, t2))
#' print(ds)
pr_dataset <- function(trials, group_var = "condition", name = "dataset") {
  if (!is.list(trials) ||
      !all(vapply(trials, inherits, logical(1), "pr_trial"))) {
    cli::cli_abort("{.arg trials} must be a list of {.cls pr_trial} objects.")
  }
  structure(
    list(
      trials = trials,
      n_trials = length(trials),
      group_var = group_var,
      name = name
    ),
    class = "pr_dataset"
  )
}

#' @export
print.pr_dataset <- function(x, ...) {
  meta <- lapply(x$trials, function(t) t$metadata)
  subjects <- unique(vapply(meta, function(m) {
    s <- m$subject_id
    if (is.null(s) || (length(s) == 1L && is.na(s))) "-" else as.character(s)
  }, character(1)))
  conditions <- unique(vapply(meta, function(m) {
    c_ <- m$condition
    if (is.null(c_) || (length(c_) == 1L && is.na(c_))) "-" else as.character(c_)
  }, character(1)))
  layouts <- unique(vapply(x$trials, function(t) t$layout$name, character(1)))

  cli::cli_h1("pr_dataset: {x$name}")
  cli::cli_ul(c(
    "Trials: {.val {x$n_trials}}",
    "Subjects: {.val {subjects}}",
    "Conditions: {.val {conditions}}",
    "Layouts: {.val {layouts}}"
  ))
  invisible(x)
}

#' @export
summary.pr_dataset <- function(object, ...) {
  pr_batch_summary(object)
}

#' @export
c.pr_dataset <- function(...) {
  ds_list <- list(...)
  all_trials <- unlist(lapply(ds_list, function(d) {
    if (inherits(d, "pr_dataset")) d$trials else list(d)
  }), recursive = FALSE)
  pr_dataset(all_trials, name = "combined")
}

#' @export
length.pr_dataset <- function(x) x$n_trials

#' @export
`[.pr_dataset` <- function(x, i) {
  subset_trials <- x$trials[i]
  pr_dataset(subset_trials, group_var = x$group_var, name = x$name)
}
