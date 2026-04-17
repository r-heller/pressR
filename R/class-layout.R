#' Create a Pressure Sensor Layout
#'
#' Defines the physical arrangement of sensors in a pressure measurement
#' system, including grid dimensions, active sensor positions, physical
#' coordinates, and named region masks.
#'
#' @param grid_rows Integer. Number of rows in the sensor grid.
#' @param grid_cols Integer. Number of columns in the sensor grid.
#' @param active Logical matrix of dimensions `grid_rows x grid_cols`.
#'   `TRUE` for cells that contain active sensors.
#' @param coords_mm Data frame with columns `sensor_id` (integer),
#'   `row` (integer), `col` (integer), `x_mm` (numeric), `y_mm` (numeric).
#'   Physical coordinates of each active sensor in millimeters.
#' @param regions Named list of logical matrices (same dims as `active`).
#'   Each entry defines an anatomical or functional region.
#' @param sensor_area_cm2 Numeric. Area of a single sensor cell in cm².
#' @param pressure_range Numeric vector of length 2. Min and max measurable
#'   pressure in kPa.
#' @param pressure_unit Character. Unit of pressure measurement. Default `"kPa"`.
#' @param name Character. Short identifier for this layout
#'   (e.g., `"pedar_standard"`).
#' @param description Character. Human-readable description.
#' @param manufacturer Character. Sensor manufacturer. Default `""`.
#' @param model Character. Sensor model/system name.
#'
#' @return A `pr_layout` S3 object (list with class attribute).
#' @export
#' @examples
#' active <- matrix(TRUE, 4, 4)
#' coords <- data.frame(
#'   sensor_id = seq_len(16),
#'   row = rep(1:4, each = 4),
#'   col = rep(1:4, times = 4),
#'   x_mm = rep(seq(0, 30, 10), times = 4),
#'   y_mm = rep(seq(0, 30, 10), each = 4)
#' )
#' layout <- pr_layout(4, 4, active, coords, name = "example_4x4")
#' print(layout)
pr_layout <- function(grid_rows, grid_cols, active, coords_mm,
                      regions = list(), sensor_area_cm2 = 1.0,
                      pressure_range = c(0, 600), pressure_unit = "kPa",
                      name = "custom", description = "",
                      manufacturer = "", model = "") {

  if (!is.numeric(grid_rows) || length(grid_rows) != 1L || grid_rows <= 0) {
    cli::cli_abort("{.arg grid_rows} must be a single positive integer.")
  }
  if (!is.numeric(grid_cols) || length(grid_cols) != 1L || grid_cols <= 0) {
    cli::cli_abort("{.arg grid_cols} must be a single positive integer.")
  }
  if (!is.logical(active) || !is.matrix(active)) {
    cli::cli_abort("{.arg active} must be a logical matrix.")
  }
  if (nrow(active) != grid_rows || ncol(active) != grid_cols) {
    cli::cli_abort(
      "{.arg active} dimensions ({nrow(active)}x{ncol(active)}) do not
       match {.arg grid_rows}x{.arg grid_cols} ({grid_rows}x{grid_cols})."
    )
  }
  if (!is.data.frame(coords_mm)) {
    cli::cli_abort("{.arg coords_mm} must be a data frame.")
  }
  required_cols <- c("sensor_id", "row", "col", "x_mm", "y_mm")
  missing <- setdiff(required_cols, names(coords_mm))
  if (length(missing) > 0L) {
    cli::cli_abort(
      "{.arg coords_mm} is missing required column(s): {.val {missing}}."
    )
  }
  if (nrow(coords_mm) != sum(active)) {
    cli::cli_abort(
      "{.arg coords_mm} has {nrow(coords_mm)} row(s) but {.arg active}
       has {sum(active)} active sensor(s)."
    )
  }
  if (!is.list(regions)) {
    cli::cli_abort("{.arg regions} must be a named list of logical matrices.")
  }
  if (length(regions) > 0L && is.null(names(regions))) {
    cli::cli_abort("{.arg regions} must be a *named* list.")
  }
  for (nm in names(regions)) {
    m <- regions[[nm]]
    if (!is.logical(m) || !is.matrix(m) ||
        nrow(m) != grid_rows || ncol(m) != grid_cols) {
      cli::cli_abort(
        "Region mask {.val {nm}} must be a logical matrix of dimensions
         {grid_rows} x {grid_cols}."
      )
    }
  }
  if (!is.numeric(sensor_area_cm2) || length(sensor_area_cm2) != 1L ||
      sensor_area_cm2 <= 0) {
    cli::cli_abort("{.arg sensor_area_cm2} must be a positive number.")
  }
  if (!is.numeric(pressure_range) || length(pressure_range) != 2L) {
    cli::cli_abort("{.arg pressure_range} must be numeric of length 2.")
  }

  structure(
    list(
      grid_rows = as.integer(grid_rows),
      grid_cols = as.integer(grid_cols),
      active = active,
      coords_mm = tibble::as_tibble(coords_mm),
      regions = regions,
      sensor_area_cm2 = sensor_area_cm2,
      n_sensors = sum(active),
      pressure_range = pressure_range,
      pressure_unit = pressure_unit,
      name = name,
      description = description,
      manufacturer = manufacturer,
      model = model
    ),
    class = "pr_layout"
  )
}

#' @export
print.pr_layout <- function(x, ...) {
  cli::cli_h1("pr_layout: {x$name}")
  if (nzchar(x$description)) {
    cli::cli_text("{x$description}")
  }
  cli::cli_ul(c(
    "Manufacturer: {.val {x$manufacturer}}",
    "Model: {.val {x$model}}",
    "Grid: {.val {x$grid_rows}} x {.val {x$grid_cols}}",
    "Active sensors: {.val {x$n_sensors}}",
    "Sensor area: {.val {x$sensor_area_cm2}} cm\u00b2",
    "Pressure range: {.val {x$pressure_range[1]}} - {.val {x$pressure_range[2]}} {x$pressure_unit}",
    "Regions: {.val {length(x$regions)}}"
  ))
  if (length(x$regions) > 0L) {
    cli::cli_text("Region names: {.val {names(x$regions)}}")
  }
  invisible(x)
}

#' @export
summary.pr_layout <- function(object, ...) {
  out <- list(
    name = object$name,
    grid = c(rows = object$grid_rows, cols = object$grid_cols),
    n_sensors = object$n_sensors,
    sensor_area_cm2 = object$sensor_area_cm2,
    total_area_cm2 = object$n_sensors * object$sensor_area_cm2,
    n_regions = length(object$regions),
    region_names = names(object$regions)
  )
  class(out) <- "summary.pr_layout"
  out
}

#' @export
print.summary.pr_layout <- function(x, ...) {
  cli::cli_h2("Summary of pr_layout: {x$name}")
  cli::cli_ul(c(
    "Grid: {.val {x$grid[['rows']]}} x {.val {x$grid[['cols']]}}",
    "Active sensors: {.val {x$n_sensors}}",
    "Total sensor area: {.val {round(x$total_area_cm2, 2)}} cm\u00b2",
    "Regions: {.val {x$n_regions}}"
  ))
  invisible(x)
}

#' Plot a Sensor Layout
#'
#' Visualizes a [pr_layout] showing active sensor positions and colored
#' region masks (if any).
#'
#' @param x A [pr_layout] object.
#' @param show_regions Logical. If `TRUE` (default), draws region masks
#'   in colors. If `FALSE`, shows only sensor positions.
#' @param show_ids Logical. If `TRUE`, labels each sensor with its id.
#'   Default `FALSE`.
#' @param ... Not used.
#'
#' @return A `ggplot2` object.
#' @export
#' @examples
#' plot(pr_layout_saddle("horse"))
plot.pr_layout <- function(x, show_regions = TRUE, show_ids = FALSE, ...) {
  coords <- x$coords_mm

  p <- ggplot2::ggplot(coords, ggplot2::aes(x = .data$x_mm, y = .data$y_mm))

  if (show_regions && length(x$regions) > 0L) {
    region_df <- .regions_to_df(x)
    p <- p +
      ggplot2::geom_tile(
        data = region_df,
        ggplot2::aes(x = .data$x_mm, y = .data$y_mm, fill = .data$region),
        width = sqrt(x$sensor_area_cm2) * 10,
        height = sqrt(x$sensor_area_cm2) * 10,
        alpha = 0.5
      )
  }

  p <- p +
    ggplot2::geom_point(size = 1.5, color = "#1A2332") +
    ggplot2::coord_fixed() +
    ggplot2::labs(
      title = sprintf("Layout: %s", x$name),
      subtitle = sprintf("%d sensors \u00b7 %s",
                         x$n_sensors,
                         if (nzchar(x$model)) x$model else "custom"),
      x = "x (mm)",
      y = "y (mm)",
      fill = "Region"
    ) +
    ggplot2::theme_minimal(base_size = 11)

  if (show_ids) {
    p <- p + ggplot2::geom_text(
      ggplot2::aes(label = .data$sensor_id),
      size = 2, vjust = -1
    )
  }

  p
}

# Internal: validate a pr_layout argument
.validate_layout <- function(layout) {
  if (!inherits(layout, "pr_layout")) {
    cli::cli_abort("{.arg layout} must be a {.cls pr_layout} object.")
  }
  invisible(layout)
}

# Internal: convert regions list to a long tibble for plotting
.regions_to_df <- function(layout) {
  coords <- layout$coords_mm
  out <- list()
  for (nm in names(layout$regions)) {
    m <- layout$regions[[nm]]
    rr <- which(m, arr.ind = TRUE)
    # rr columns: row, col
    idx_ok <- mapply(
      function(rw, cc) {
        hit <- coords$row == rw & coords$col == cc
        if (any(hit)) which(hit)[1] else NA_integer_
      },
      rr[, 1], rr[, 2]
    )
    idx_ok <- idx_ok[!is.na(idx_ok)]
    if (length(idx_ok) > 0L) {
      sub <- coords[idx_ok, , drop = FALSE]
      sub$region <- nm
      out[[nm]] <- sub
    }
  }
  if (length(out) == 0L) {
    return(tibble::tibble(
      sensor_id = integer(), row = integer(), col = integer(),
      x_mm = numeric(), y_mm = numeric(), region = character()
    ))
  }
  do.call(rbind, out)
}

#' Validate a Pressure Sensor Layout
#'
#' Checks internal consistency of a [pr_layout] object.
#'
#' @param layout A [pr_layout] object.
#'
#' @return Invisibly returns `TRUE` if valid; otherwise throws an informative
#'   error.
#' @export
#' @examples
#' pr_validate_layout(pr_layout_pedar())
pr_validate_layout <- function(layout) {
  .validate_layout(layout)

  if (nrow(layout$active) != layout$grid_rows ||
      ncol(layout$active) != layout$grid_cols) {
    cli::cli_abort("Active matrix dimensions inconsistent with grid size.")
  }
  if (layout$n_sensors != sum(layout$active)) {
    cli::cli_abort("Sensor count does not match {.code sum(active)}.")
  }
  if (nrow(layout$coords_mm) != layout$n_sensors) {
    cli::cli_abort("Coordinate count does not match sensor count.")
  }
  for (nm in names(layout$regions)) {
    m <- layout$regions[[nm]]
    if (nrow(m) != layout$grid_rows || ncol(m) != layout$grid_cols) {
      cli::cli_abort("Region {.val {nm}} has wrong dimensions.")
    }
    if (any(m & !layout$active)) {
      cli::cli_warn("Region {.val {nm}} covers inactive cells.")
    }
  }
  invisible(TRUE)
}
