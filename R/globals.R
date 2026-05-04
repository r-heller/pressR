#' @importFrom rlang .data
#' @importFrom rlang .env
NULL

# Suppress R CMD check notes for tidy evaluation bindings
utils::globalVariables(c(
  "sensor_id", "row", "col", "x_mm", "y_mm", "pressure",
  "frame", "time", "region", "value", "parameter",
  "left", "right", "symmetry_index", "cycle", "percent_stance",
  "cop_x_mm", "cop_y_mm", "cop_velocity", "force", "contact_area",
  "mpp", "mvp", "threshold", "interpretation", "source",
  "max_force", "mean_force", "max_contact_area", "mean_contact_area",
  "contact_time", "pti_max", "pti_mean", "impulse",
  "cop_path_length", "cop_velocity_mean", "cop_range_ap", "cop_range_ml",
  "heel_strike_frame", "toe_off_frame", "heel_strike_time",
  "toe_off_time", "stance_duration", "start_frame", "end_frame",
  "max_pressure", "mean_pressure", "duration_above_s"
))
