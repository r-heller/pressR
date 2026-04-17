#' Create a Region Mask
#'
#' Wraps a logical matrix describing a named region over a sensor layout.
#'
#' @param mask_matrix Logical matrix matching the dimensions of `layout$active`.
#' @param name Character. Region name.
#' @param layout A [pr_layout] object this mask applies to.
#'
#' @return A `pr_mask` S3 object.
#' @export
#' @examples
#' layout <- pr_layout_saddle("horse")
#' m <- layout$regions$cranial_left
#' pr_mask(m, "cranial_left", layout)
pr_mask <- function(mask_matrix, name, layout) {
  .validate_layout(layout)
  if (!is.logical(mask_matrix) || !is.matrix(mask_matrix)) {
    cli::cli_abort("{.arg mask_matrix} must be a logical matrix.")
  }
  if (nrow(mask_matrix) != layout$grid_rows ||
      ncol(mask_matrix) != layout$grid_cols) {
    cli::cli_abort(
      "{.arg mask_matrix} dimensions must match layout grid
       ({layout$grid_rows} x {layout$grid_cols})."
    )
  }
  if (!is.character(name) || length(name) != 1L) {
    cli::cli_abort("{.arg name} must be a single string.")
  }

  # Determine active-sensor-column indices hit by this mask
  active_idx <- which(layout$active)
  mask_idx <- which(mask_matrix & layout$active)
  sensor_cols <- match(mask_idx, active_idx)

  structure(
    list(
      name = name,
      matrix = mask_matrix,
      layout_name = layout$name,
      grid_rows = layout$grid_rows,
      grid_cols = layout$grid_cols,
      sensor_cols = sensor_cols,
      n_sensors = length(sensor_cols)
    ),
    class = "pr_mask"
  )
}

#' @export
print.pr_mask <- function(x, ...) {
  cli::cli_h2("pr_mask: {x$name}")
  cli::cli_ul(c(
    "Layout: {.val {x$layout_name}}",
    "Grid: {.val {x$grid_rows}} x {.val {x$grid_cols}}",
    "Sensors covered: {.val {x$n_sensors}}"
  ))
  invisible(x)
}

# Internal helper: coerce a mask input (pr_mask or logical matrix) to
# pressure-matrix column indices, given a layout.
.mask_to_cols <- function(mask_input, layout) {
  if (inherits(mask_input, "pr_mask")) {
    return(mask_input$sensor_cols)
  }
  if (is.logical(mask_input) && is.matrix(mask_input)) {
    active_idx <- which(layout$active)
    mask_idx <- which(mask_input & layout$active)
    return(match(mask_idx, active_idx))
  }
  cli::cli_abort(
    "Mask must be a {.cls pr_mask} object or a logical matrix."
  )
}
