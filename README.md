<!-- README.md is generated from README.Rmd. Please edit that file. -->

# pressR <img src="man/figures/logo.png" align="right" height="139" alt="pressR logo" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/r-heller/pressR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-heller/pressR/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/r-heller/pressR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-heller/pressR?branch=main)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

**pressR** parses, analyses, and visualises pressure distribution data
from capacitive sensor systems.
It ships with predefined layouts, along with an interactive Shiny application for
data exploration.

## Installation

```r
# install.packages("pak")
pak::pak("r-heller/pressR")
```

## Quick example

```r
library(pressR)

trial <- pr_example_trial("pedar")

pr_plot_heatmap(trial)
pr_plot_force_time(trial, show_cycles = TRUE)

pr_summary(trial)
pr_calc_regional(trial)
```

## Features

* **Parsers** for novel ASCII exports, generic CSV, loadsol data,
  and novel mask files (`.msa`/`.msr`/`.msp`).
* **Per-frame and per-trial analysis**: peak pressure, mean pressure,
  force, contact area, pressure-time integral, centre of pressure,
  symmetry index, gait cycle detection, and COP rollover pattern.
* **Visualisation**: 2D and 3D heatmaps, dynamics plots, regional bar
  charts, composite report panels, and side-by-side trial comparison.
* **Shiny app** (`pr_run_app()`) for interactive import, analysis, and
  export.

## Vignettes

* `vignette("getting-started", package = "pressR")`
* `vignette("saddle-pressure-analysis", package = "pressR")`
* `vignette("foot-pressure-analysis", package = "pressR")`

## License

MIT © Raban Heller.
