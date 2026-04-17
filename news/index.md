# Changelog

## pressR 0.1.0

### Initial release

#### Parsers

- [`pr_read_ascii()`](https://r-heller.github.io/pressR/reference/pr_read_ascii.md):
  Parse ASCII pressure data exports.
- [`pr_read_csv()`](https://r-heller.github.io/pressR/reference/pr_read_csv.md):
  Parse generic CSV pressure data (wide or long).
- [`pr_read_forcesensor()`](https://r-heller.github.io/pressR/reference/pr_read_forcesensor.md):
  Parse force sensor data.
- [`pr_read_mask()`](https://r-heller.github.io/pressR/reference/pr_read_mask.md):
  Parse region mask files.
- [`pr_read_auto()`](https://r-heller.github.io/pressR/reference/pr_read_auto.md):
  Auto-detect and dispatch.

#### Sensor Layouts

- [`pr_layout()`](https://r-heller.github.io/pressR/reference/pr_layout.md):
  Construct custom layouts.
- [`pr_layout_insole()`](https://r-heller.github.io/pressR/reference/pr_layout_insole.md),
  [`pr_layout_platform()`](https://r-heller.github.io/pressR/reference/pr_layout_platform.md),
  [`pr_layout_mat()`](https://r-heller.github.io/pressR/reference/pr_layout_mat.md),
  [`pr_layout_saddle()`](https://r-heller.github.io/pressR/reference/pr_layout_saddle.md),
  [`pr_layout_seat()`](https://r-heller.github.io/pressR/reference/pr_layout_seat.md),
  [`pr_layout_glove()`](https://r-heller.github.io/pressR/reference/pr_layout_glove.md):
  predefined layouts.
- [`pr_layout_list()`](https://r-heller.github.io/pressR/reference/pr_layout_list.md)
  lists available layouts.
- [`pr_validate_layout()`](https://r-heller.github.io/pressR/reference/pr_validate_layout.md)
  validates a layout.

#### S3 classes

- `pr_layout`, `pr_trial`, `pr_dataset`, `pr_cop`, `pr_mask`.

#### Region Masks

- [`pr_mask()`](https://r-heller.github.io/pressR/reference/pr_mask.md),
  [`pr_mask_default()`](https://r-heller.github.io/pressR/reference/pr_mask_default.md),
  [`pr_mask_apply()`](https://r-heller.github.io/pressR/reference/pr_mask_apply.md),
  [`pr_mask_saddle_6()`](https://r-heller.github.io/pressR/reference/pr_mask_saddle_6.md),
  [`pr_mask_symmetry()`](https://r-heller.github.io/pressR/reference/pr_mask_symmetry.md),
  [`pr_mask_foot_auto()`](https://r-heller.github.io/pressR/reference/pr_mask_foot_auto.md).

#### Per-frame and trial analysis

- [`pr_calc_peak_pressure()`](https://r-heller.github.io/pressR/reference/pr_calc_peak_pressure.md),
  [`pr_calc_mean_pressure()`](https://r-heller.github.io/pressR/reference/pr_calc_mean_pressure.md),
  [`pr_calc_force()`](https://r-heller.github.io/pressR/reference/pr_calc_force.md),
  [`pr_calc_contact_area()`](https://r-heller.github.io/pressR/reference/pr_calc_contact_area.md),
  [`pr_calc_cop()`](https://r-heller.github.io/pressR/reference/pr_calc_cop.md),
  [`pr_calc_loaded_rate()`](https://r-heller.github.io/pressR/reference/pr_calc_loaded_rate.md),
  [`pr_calc_pti()`](https://r-heller.github.io/pressR/reference/pr_calc_pti.md),
  [`pr_calc_impulse()`](https://r-heller.github.io/pressR/reference/pr_calc_impulse.md),
  [`pr_calc_contact_time()`](https://r-heller.github.io/pressR/reference/pr_calc_contact_time.md),
  [`pr_calc_cop_path()`](https://r-heller.github.io/pressR/reference/pr_calc_cop_path.md),
  [`pr_calc_cop_excursion()`](https://r-heller.github.io/pressR/reference/pr_calc_cop_excursion.md).
- [`pr_summary()`](https://r-heller.github.io/pressR/reference/pr_summary.md):
  comprehensive trial summary.
- [`pr_calc_symmetry_index()`](https://r-heller.github.io/pressR/reference/pr_calc_symmetry_index.md),
  [`pr_calc_regional()`](https://r-heller.github.io/pressR/reference/pr_calc_regional.md).

#### Application-specific analysis

- Gait:
  [`pr_calc_gait_cycles()`](https://r-heller.github.io/pressR/reference/pr_calc_gait_cycles.md),
  [`pr_calc_rollover()`](https://r-heller.github.io/pressR/reference/pr_calc_rollover.md).
- Saddle:
  [`pr_calc_saddle_bridge()`](https://r-heller.github.io/pressR/reference/pr_calc_saddle_bridge.md),
  [`pr_calc_saddle_slip()`](https://r-heller.github.io/pressR/reference/pr_calc_saddle_slip.md).
- Seating:
  [`pr_calc_seat_hotspot()`](https://r-heller.github.io/pressR/reference/pr_calc_seat_hotspot.md).

#### Reference thresholds

- [`pr_ref_saddle()`](https://r-heller.github.io/pressR/reference/pr_ref_saddle.md),
  [`pr_ref_diabetic_foot()`](https://r-heller.github.io/pressR/reference/pr_ref_diabetic_foot.md),
  [`pr_ref_wheelchair()`](https://r-heller.github.io/pressR/reference/pr_ref_wheelchair.md).

#### Visualization

- [`pr_plot_heatmap()`](https://r-heller.github.io/pressR/reference/pr_plot_heatmap.md),
  [`pr_plot_heatmap_masked()`](https://r-heller.github.io/pressR/reference/pr_plot_heatmap_masked.md),
  [`pr_plot_3d()`](https://r-heller.github.io/pressR/reference/pr_plot_3d.md),
  [`pr_plot_force_time()`](https://r-heller.github.io/pressR/reference/pr_plot_force_time.md),
  [`pr_plot_pressure_time()`](https://r-heller.github.io/pressR/reference/pr_plot_pressure_time.md),
  [`pr_plot_cop()`](https://r-heller.github.io/pressR/reference/pr_plot_cop.md),
  [`pr_plot_cop_butterfly()`](https://r-heller.github.io/pressR/reference/pr_plot_cop_butterfly.md),
  [`pr_plot_contact_area()`](https://r-heller.github.io/pressR/reference/pr_plot_contact_area.md),
  [`pr_plot_regional_bar()`](https://r-heller.github.io/pressR/reference/pr_plot_regional_bar.md),
  [`pr_plot_symmetry()`](https://r-heller.github.io/pressR/reference/pr_plot_symmetry.md),
  [`pr_plot_comparison()`](https://r-heller.github.io/pressR/reference/pr_plot_comparison.md),
  [`pr_plot_saddle_report()`](https://r-heller.github.io/pressR/reference/pr_plot_saddle_report.md),
  [`pr_plot_foot_report()`](https://r-heller.github.io/pressR/reference/pr_plot_foot_report.md).

#### Export and reporting

- [`pr_export_csv()`](https://r-heller.github.io/pressR/reference/pr_export_csv.md),
  [`pr_export_report()`](https://r-heller.github.io/pressR/reference/pr_export_report.md).

#### Batch processing

- [`pr_batch_summary()`](https://r-heller.github.io/pressR/reference/pr_batch_summary.md),
  [`pr_merge_trials()`](https://r-heller.github.io/pressR/reference/pr_merge_trials.md).

#### Shiny application

- [`pr_run_app()`](https://r-heller.github.io/pressR/reference/pr_run_app.md):
  interactive 6-tab data explorer.

#### Example data

- [`pr_example_trial()`](https://r-heller.github.io/pressR/reference/pr_example_trial.md),
  [`pr_example_files()`](https://r-heller.github.io/pressR/reference/pr_example_files.md).

#### Utilities

- [`pr_interpolate()`](https://r-heller.github.io/pressR/reference/pr_interpolate.md),
  [`pr_filter_time()`](https://r-heller.github.io/pressR/reference/pr_filter_time.md),
  [`pr_downsample()`](https://r-heller.github.io/pressR/reference/pr_downsample.md).
