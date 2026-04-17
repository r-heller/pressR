#' Batch Summary Across Multiple Trials
#'
#' Runs [pr_summary()] on each trial in a dataset and row-binds the
#' results, prepending trial metadata columns.
#'
#' @param dataset A [pr_dataset] object or a list of [pr_trial] objects.
#'
#' @return A [tibble::tibble] with one row per trial.
#' @export
#' @examples
#' ds <- pr_dataset(list(
#'   pr_example_trial("pedar", seed = 1),
#'   pr_example_trial("pedar", seed = 2)
#' ))
#' pr_batch_summary(ds)
pr_batch_summary <- function(dataset) {
  trials <- if (inherits(dataset, "pr_dataset")) dataset$trials else dataset
  if (!is.list(trials) ||
      !all(vapply(trials, inherits, logical(1), "pr_trial"))) {
    cli::cli_abort("{.arg dataset} must be a {.cls pr_dataset} or list of {.cls pr_trial}.")
  }

  rows <- lapply(trials, function(t) {
    s <- pr_summary(t)
    md <- t$metadata
    meta_row <- tibble::tibble(
      subject_id = as.character(md$subject_id %||% NA),
      trial_id = as.character(md$trial_id %||% NA),
      condition = as.character(md$condition %||% NA),
      system = as.character(md$system %||% NA),
      n_frames = t$n_frames,
      duration = t$duration
    )
    dplyr::bind_cols(meta_row, s)
  })
  do.call(rbind, rows)
}

#' Merge Trials into a Dataset
#'
#' @param ... [pr_trial] objects or lists of them.
#' @param group_var Character. Name of a metadata field to use as the
#'   grouping variable.
#'
#' @return A [pr_dataset] object.
#' @export
#' @examples
#' pr_merge_trials(
#'   pr_example_trial("pedar", seed = 1),
#'   pr_example_trial("pedar", seed = 2)
#' )
pr_merge_trials <- function(..., group_var = "condition") {
  args <- list(...)
  all_trials <- unlist(
    lapply(args, function(a) if (inherits(a, "pr_trial")) list(a) else a),
    recursive = FALSE
  )
  if (!all(vapply(all_trials, inherits, logical(1), "pr_trial"))) {
    cli::cli_abort("All arguments must be pr_trial objects or lists of them.")
  }
  pr_dataset(all_trials, group_var = group_var)
}
