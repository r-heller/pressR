# ---------------------------------------------------------------------------
# Predefined sensor layouts.
#
# Each public factory function constructs a pr_layout with realistic
# geometry for a specific application. Layouts are generated
# programmatically (not loaded from external JSON) so they are always
# self-consistent and do not bloat the package source.
# ---------------------------------------------------------------------------

.layout_build_coords <- function(active, spacing_mm = 10) {
  idx <- which(active, arr.ind = TRUE)
  if (nrow(idx) == 0L) {
    return(tibble::tibble(
      sensor_id = integer(), row = integer(), col = integer(),
      x_mm = numeric(), y_mm = numeric()
    ))
  }
  tibble::tibble(
    sensor_id = seq_len(nrow(idx)),
    row = as.integer(idx[, 1]),
    col = as.integer(idx[, 2]),
    x_mm = (idx[, 2] - 1) * spacing_mm,
    y_mm = (idx[, 1] - 1) * spacing_mm
  )
}

# ---------- pedar insole ---------------------------------------------------

# Build a 99-sensor foot-shaped active mask on an 18x8 grid.
# Rows are ordered with row 1 at the toes (top) and row 18 at the heel (bottom)
# in data-space. We use y_mm such that toes have the highest y_mm.
.pedar_active_mask <- function() {
  # Predefined "active" pattern per row (TRUE/FALSE, length 8).
  # Total must equal 99. Shape: narrow toes, wide forefoot, narrow midfoot,
  # wider heel. Approximate representation (not identical to real pedar).
  # Columns 1..8 (medial=1, lateral=8).
  m <- matrix(FALSE, nrow = 18, ncol = 8)

  # Target total = 99 sensors across an 18 x 8 grid.
  # row 1 (toes - hallux + lesser toes)
  m[1, 2:7] <- TRUE   # 6
  # row 2 (toe base)
  m[2, 2:7] <- TRUE   # 6
  # row 3 (metatarsal heads)
  m[3, 1:8] <- TRUE   # 8
  # row 4 (metatarsal heads)
  m[4, 1:8] <- TRUE   # 8
  # row 5 (distal midfoot)
  m[5, 1:7] <- TRUE   # 7
  # row 6 (midfoot)
  m[6, 2:7] <- TRUE   # 6
  # row 7 (midfoot)
  m[7, 3:7] <- TRUE   # 5
  # row 8 (midfoot / arch)
  m[8, 3:7] <- TRUE   # 5
  # row 9 (arch)
  m[9, 3:7] <- TRUE   # 5
  # row 10 (arch)
  m[10, 3:7] <- TRUE  # 5
  # row 11 (proximal midfoot)
  m[11, 3:7] <- TRUE  # 5
  # row 12 (proximal midfoot)
  m[12, 3:7] <- TRUE  # 5
  # row 13 (distal heel)
  m[13, 2:6] <- TRUE  # 5
  # row 14 (heel)
  m[14, 1:7] <- TRUE  # 7
  # row 15 (heel)
  m[15, 1:7] <- TRUE  # 7
  # row 16 (heel)
  m[16, 3:6] <- TRUE  # 4
  # row 17 (heel)
  m[17, 3:5] <- TRUE  # 3
  # row 18 (heel tip)
  m[18, 3:4] <- TRUE  # 2

  # Sum: 6+6+8+8+7+6+5+5+5+5+5+5+5+7+7+4+3+2 = 99
  stopifnot(sum(m) == 99)
  m
}

.pedar_regions <- function(active) {
  reg <- list()
  # Heel: rows 13-18
  m <- matrix(FALSE, 18, 8); m[13:18, ] <- TRUE; m <- m & active
  reg$heel <- m
  # Midfoot: rows 5-12
  m <- matrix(FALSE, 18, 8); m[5:12, ] <- TRUE; m <- m & active
  reg$midfoot <- m
  # Metatarsal 1 (medial): rows 3-4, col 1-2
  m <- matrix(FALSE, 18, 8); m[3:4, 1:2] <- TRUE; m <- m & active
  reg$metatarsal_1 <- m
  # Metatarsal 2-3 (central): rows 3-4, cols 3-5
  m <- matrix(FALSE, 18, 8); m[3:4, 3:5] <- TRUE; m <- m & active
  reg$metatarsal_2_3 <- m
  # Metatarsal 4-5 (lateral): rows 3-4, cols 6-8
  m <- matrix(FALSE, 18, 8); m[3:4, 6:8] <- TRUE; m <- m & active
  reg$metatarsal_4_5 <- m
  # Hallux (great toe): rows 1-2, cols 2-3
  m <- matrix(FALSE, 18, 8); m[1:2, 2:3] <- TRUE; m <- m & active
  reg$hallux <- m
  # Lesser toes: rows 1-2, cols 4-7
  m <- matrix(FALSE, 18, 8); m[1:2, 4:7] <- TRUE; m <- m & active
  reg$lesser_toes <- m

  reg
}

#' Get pedar In-Shoe Pressure Insole Layout
#'
#' Returns a [pr_layout] representing the novel pedar in-shoe pressure
#' measurement system. The insole contains 99 capacitive sensors arranged
#' in an anatomically shaped grid.
#'
#' @param size Character. Insole size variant: `"standard"` (default) or
#'   `"wide"` (diabetic/wide-fit shoe insole with broader sensor spacing).
#'
#' @return A [pr_layout] object with predefined foot region masks.
#' @export
#' @examples
#' layout <- pr_layout_pedar()
#' print(layout)
pr_layout_pedar <- function(size = c("standard", "wide")) {
  size <- match.arg(size)
  active <- .pedar_active_mask()
  spacing <- if (size == "wide") 12 else 10
  coords <- .layout_build_coords(active, spacing_mm = spacing)

  # Reposition y so toes have the highest y_mm (row 1 at top).
  coords$y_mm <- (max(coords$row) - coords$row) * spacing

  regions <- .pedar_regions(active)

  pr_layout(
    grid_rows = 18, grid_cols = 8,
    active = active,
    coords_mm = coords,
    regions = regions,
    sensor_area_cm2 = 1.5,
    pressure_range = c(0, 1200),
    pressure_unit = "kPa",
    name = sprintf("pedar_%s", size),
    description = sprintf(
      "pedar in-shoe pressure insole (99 sensors, %s).", size
    ),
    manufacturer = "novel GmbH",
    model = "pedar"
  )
}

# ---------- emed platform --------------------------------------------------

.emed_active_mask <- function() {
  # 64 x 40 grid, active center "stripe" wide enough to capture a foot.
  m <- matrix(FALSE, 64, 40)
  m[5:60, 5:36] <- TRUE
  m
}

#' Get emed Pressure Platform Layout
#'
#' Returns a [pr_layout] for the novel emed barefoot pressure platform.
#' Provides high-resolution plantar pressure distribution during static
#' and dynamic conditions.
#'
#' @param model Character. Platform model: `"st"` (standard, default),
#'   `"xl"` (extended length), or `"cl"` (clinical/compact).
#'
#' @return A [pr_layout] object. Region masks are not predefined — use
#'   [pr_mask_foot_auto()] to auto-segment footprints from the data.
#' @export
#' @examples
#' layout <- pr_layout_emed()
#' layout$grid_rows
#' layout$grid_cols
pr_layout_emed <- function(model = c("st", "xl", "cl")) {
  model <- match.arg(model)
  active <- switch(
    model,
    st = .emed_active_mask(),
    xl = {
      m <- matrix(FALSE, 96, 40)
      m[5:92, 5:36] <- TRUE
      m
    },
    cl = {
      m <- matrix(FALSE, 48, 32)
      m[5:44, 3:30] <- TRUE
      m
    }
  )
  coords <- .layout_build_coords(active, spacing_mm = 5)

  pr_layout(
    grid_rows = nrow(active), grid_cols = ncol(active),
    active = active,
    coords_mm = coords,
    regions = list(),
    sensor_area_cm2 = 0.25,
    pressure_range = c(0, 1270),
    pressure_unit = "kPa",
    name = sprintf("emed_%s", model),
    description = sprintf(
      "emed barefoot pressure platform (%s).", toupper(model)
    ),
    manufacturer = "novel GmbH",
    model = "emed"
  )
}

# ---------- pliance mat ----------------------------------------------------

#' Get pliance Sensor Mat Layout
#'
#' Returns a [pr_layout] for a generic pliance sensor mat. pliance mats
#' are general-purpose capacitive pressure sensor arrays used in research,
#' seating, sports, and ergonomics.
#'
#' @param size Character. `"16"` (default) for 16x16 = 256 sensors or
#'   `"32"` for 32x32 = 1024 sensors.
#'
#' @return A [pr_layout] with no predefined regions.
#' @export
pr_layout_pliance <- function(size = c("16", "32")) {
  size <- match.arg(size)
  n <- as.integer(size)
  active <- matrix(TRUE, n, n)
  coords <- .layout_build_coords(active, spacing_mm = 25.4)

  pr_layout(
    grid_rows = n, grid_cols = n,
    active = active,
    coords_mm = coords,
    regions = list(),
    sensor_area_cm2 = 6.25,
    pressure_range = c(0, 600),
    pressure_unit = "kPa",
    name = sprintf("pliance_%s", size),
    description = sprintf("pliance sensor mat (%sx%s).", n, n),
    manufacturer = "novel GmbH",
    model = "pliance"
  )
}

# ---------- saddle: horse / bicycle ---------------------------------------

.saddle_horse_active <- function() {
  # 16 x 16 sensor mat with withers cutout at cranial center
  m <- matrix(TRUE, 16, 16)
  # Withers cutout: rows 1-2, cols 7-10
  m[1:2, 7:10] <- FALSE
  m
}

.saddle_horse_regions <- function(active) {
  # Thirds along the length (rows 1-16): 1-5 cranial, 6-11 middle, 12-16 caudal
  reg <- list()
  cranial <- matrix(FALSE, 16, 16); cranial[1:5, ] <- TRUE
  middle  <- matrix(FALSE, 16, 16); middle[6:11, ] <- TRUE
  caudal  <- matrix(FALSE, 16, 16); caudal[12:16, ] <- TRUE
  left    <- matrix(FALSE, 16, 16); left[, 1:8] <- TRUE
  right   <- matrix(FALSE, 16, 16); right[, 9:16] <- TRUE

  reg$cranial_left  <- cranial & left  & active
  reg$cranial_right <- cranial & right & active
  reg$middle_left   <- middle  & left  & active
  reg$middle_right  <- middle  & right & active
  reg$caudal_left   <- caudal  & left  & active
  reg$caudal_right  <- caudal  & right & active
  reg
}

.saddle_bicycle_active <- function() {
  matrix(TRUE, 12, 16)
}

.saddle_bicycle_regions <- function(active) {
  reg <- list()
  # Ischial zones: rear, left/right
  lisch <- matrix(FALSE, 12, 16); lisch[9:12, 1:7]   <- TRUE
  risch <- matrix(FALSE, 12, 16); risch[9:12, 10:16] <- TRUE
  # Perineal: rear center
  per   <- matrix(FALSE, 12, 16); per[9:12, 8:9]     <- TRUE
  # Anterior: front
  ant   <- matrix(FALSE, 12, 16); ant[1:8, ]         <- TRUE
  reg$left_ischial  <- lisch & active
  reg$right_ischial <- risch & active
  reg$perineal      <- per   & active
  reg$anterior      <- ant   & active
  reg
}

#' Get Saddle Pressure Mat Layout
#'
#' Returns a [pr_layout] for saddle pressure measurement using pliance
#' sensor mats. Includes predefined region masks based on published
#' research protocols.
#'
#' @param type Character. `"horse"` (default) for equine saddle fitting
#'   with 6-region mask (cranial / middle / caudal x left / right per
#'   Werner et al. 2002), or `"bicycle"` for bicycle saddle with
#'   ischial/perineal regions.
#'
#' @return A [pr_layout] with application-specific region masks.
#' @export
#' @examples
#' layout <- pr_layout_saddle("horse")
#' names(layout$regions)
pr_layout_saddle <- function(type = c("horse", "bicycle")) {
  type <- match.arg(type)
  if (type == "horse") {
    active <- .saddle_horse_active()
    coords <- .layout_build_coords(active, spacing_mm = 31.6)
    regions <- .saddle_horse_regions(active)
    return(pr_layout(
      grid_rows = 16, grid_cols = 16,
      active = active, coords_mm = coords, regions = regions,
      sensor_area_cm2 = 10,
      pressure_range = c(0, 120),
      pressure_unit = "kPa",
      name = "saddle_horse",
      description = "Equine saddle pressure mat (pliance Mobile-16HE) with 6-region mask.",
      manufacturer = "novel GmbH",
      model = "pliance_mobile_16"
    ))
  }
  # bicycle
  active <- .saddle_bicycle_active()
  coords <- .layout_build_coords(active, spacing_mm = 18)
  regions <- .saddle_bicycle_regions(active)
  pr_layout(
    grid_rows = 12, grid_cols = 16,
    active = active, coords_mm = coords, regions = regions,
    sensor_area_cm2 = 3.2,
    pressure_range = c(0, 100),
    pressure_unit = "kPa",
    name = "saddle_bicycle",
    description = "Bicycle saddle pressure mat (12x16).",
    manufacturer = "novel GmbH",
    model = "pliance"
  )
}

# ---------- seat ----------------------------------------------------------

.seat_wheelchair_regions <- function() {
  reg <- list()
  # 32x32: ischial tuberosities sit rear-center
  li <- matrix(FALSE, 32, 32); li[20:27, 8:14]  <- TRUE
  ri <- matrix(FALSE, 32, 32); ri[20:27, 19:25] <- TRUE
  sa <- matrix(FALSE, 32, 32); sa[25:32, 14:19] <- TRUE
  lt <- matrix(FALSE, 32, 32); lt[5:19, 6:15]   <- TRUE
  rt <- matrix(FALSE, 32, 32); rt[5:19, 18:27]  <- TRUE
  reg$left_ischial  <- li
  reg$right_ischial <- ri
  reg$sacral        <- sa
  reg$left_thigh    <- lt
  reg$right_thigh   <- rt
  reg
}

.seat_car_office_regions <- function() {
  reg <- list()
  ls <- matrix(FALSE, 32, 32); ls[17:32, 1:16]  <- TRUE
  rs <- matrix(FALSE, 32, 32); rs[17:32, 17:32] <- TRUE
  lb <- matrix(FALSE, 32, 32); lb[1:16, 1:16]   <- TRUE
  rb <- matrix(FALSE, 32, 32); rb[1:16, 17:32]  <- TRUE
  reg$left_seat_pan  <- ls
  reg$right_seat_pan <- rs
  reg$left_backrest  <- lb
  reg$right_backrest <- rb
  reg
}

#' Get Seating Pressure Mat Layout
#'
#' Returns a [pr_layout] for seating pressure assessment. Uses a 32x32
#' grid (1024 sensors) with application-specific regions.
#'
#' @param type Character. `"wheelchair"` (default), `"car"`, or `"office"`.
#'
#' @return A [pr_layout] object.
#' @export
pr_layout_seat <- function(type = c("wheelchair", "car", "office")) {
  type <- match.arg(type)
  active <- matrix(TRUE, 32, 32)
  coords <- .layout_build_coords(active, spacing_mm = 15)
  regions <- switch(
    type,
    wheelchair = .seat_wheelchair_regions(),
    car        = .seat_car_office_regions(),
    office     = .seat_car_office_regions()
  )
  pr_layout(
    grid_rows = 32, grid_cols = 32,
    active = active, coords_mm = coords, regions = regions,
    sensor_area_cm2 = 2.25,
    pressure_range = c(0, 200),
    pressure_unit = "kPa",
    name = sprintf("seat_%s", type),
    description = sprintf("Seating pressure mat (32x32) for %s.", type),
    manufacturer = "novel GmbH",
    model = "pliance"
  )
}

# ---------- glove ---------------------------------------------------------

.glove_active_mask <- function() {
  # Hand-shaped active pattern on a 12x10 grid, exactly 32 active sensors.
  m <- matrix(FALSE, 12, 10)
  # Finger tips (row 1): thumb + 4 fingers = 5
  m[1, c(3, 5, 6, 7, 9)] <- TRUE
  # Finger mid (row 2): 4 sensors
  m[2, c(5, 6, 7, 9)] <- TRUE
  # Knuckles (row 3): 5 sensors
  m[3, c(3, 5, 6, 7, 9)] <- TRUE
  # Top of palm (row 4): 6
  m[4, 4:9] <- TRUE
  # Mid palm (row 5): 6
  m[5, 4:9] <- TRUE
  # Lower palm (row 6): 6
  m[6, 4:9] <- TRUE
  # Thenar eminence tip (row 7): thumb base
  # Total 5+4+5+6+6+6 = 32
  stopifnot(sum(m) == 32)
  m
}

#' Get Pliance Glove Sensor Layout
#'
#' Returns a [pr_layout] for a pliance glove-style hand pressure sensor
#' (32 sensors across palm and fingertips).
#'
#' @return A [pr_layout] object.
#' @export
pr_layout_glove <- function() {
  active <- .glove_active_mask()
  coords <- .layout_build_coords(active, spacing_mm = 20)
  pr_layout(
    grid_rows = 12, grid_cols = 10,
    active = active,
    coords_mm = coords,
    regions = list(),
    sensor_area_cm2 = 1.0,
    pressure_range = c(0, 400),
    pressure_unit = "kPa",
    name = "glove",
    description = "Pliance glove sensor layout (32 sensors).",
    manufacturer = "novel GmbH",
    model = "pliance_glove"
  )
}

# ---------- catalog -------------------------------------------------------

#' List All Built-In Sensor Layouts
#'
#' @return A [tibble::tibble] with columns `name`, `system`, `grid_rows`,
#'   `grid_cols`, `n_sensors`, `n_regions`, `description`.
#' @export
#' @examples
#' pr_layout_list()
pr_layout_list <- function() {
  specs <- list(
    list(fn = function() pr_layout_pedar("standard")),
    list(fn = function() pr_layout_pedar("wide")),
    list(fn = function() pr_layout_emed("st")),
    list(fn = function() pr_layout_emed("xl")),
    list(fn = function() pr_layout_emed("cl")),
    list(fn = function() pr_layout_pliance("16")),
    list(fn = function() pr_layout_pliance("32")),
    list(fn = function() pr_layout_saddle("horse")),
    list(fn = function() pr_layout_saddle("bicycle")),
    list(fn = function() pr_layout_seat("wheelchair")),
    list(fn = function() pr_layout_seat("car")),
    list(fn = function() pr_layout_seat("office")),
    list(fn = function() pr_layout_glove())
  )
  rows <- lapply(specs, function(s) {
    l <- s$fn()
    tibble::tibble(
      name = l$name,
      system = l$model,
      grid_rows = l$grid_rows,
      grid_cols = l$grid_cols,
      n_sensors = l$n_sensors,
      n_regions = length(l$regions),
      description = l$description
    )
  })
  do.call(rbind, rows)
}

# Internal dispatcher used by parsers when a layout is not supplied.
.layout_by_name <- function(name) {
  switch(
    name,
    pedar_standard  = pr_layout_pedar("standard"),
    pedar_wide      = pr_layout_pedar("wide"),
    emed_st         = pr_layout_emed("st"),
    emed_xl         = pr_layout_emed("xl"),
    emed_cl         = pr_layout_emed("cl"),
    pliance_16      = pr_layout_pliance("16"),
    pliance_32      = pr_layout_pliance("32"),
    saddle_horse    = pr_layout_saddle("horse"),
    saddle_bicycle  = pr_layout_saddle("bicycle"),
    seat_wheelchair = pr_layout_seat("wheelchair"),
    seat_car        = pr_layout_seat("car"),
    seat_office     = pr_layout_seat("office"),
    glove           = pr_layout_glove(),
    NULL
  )
}

# Internal: guess a layout from sensor count.
.layout_from_n_sensors <- function(n) {
  candidates <- list(
    c(99,   "pedar_standard"),
    c(256,  "pliance_16"),
    c(1024, "pliance_32"),
    c(32,   "glove")
  )
  for (cand in candidates) {
    if (as.integer(cand[1]) == n) return(.layout_by_name(cand[2]))
  }
  NULL
}
