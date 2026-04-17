<!-- README.md is generated from README.Rmd. Please edit that file. -->

# pressR <img src="man/figures/logo.png" align="right" height="139" alt="pressR logo" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/r-heller/pressR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-heller/pressR/actions/workflows/R-CMD-check.yaml)
[![Codecov test coverage](https://codecov.io/gh/r-heller/pressR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-heller/pressR?branch=main)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

**pressR** parses, analyses, and visualises pressure distribution data
from capacitive sensor systems — including novel® emed, pedar, and
pliance platforms — plus any generic sensor matrix you define yourself.
It ships with predefined layouts for in-shoe pressure measurement,
saddle pressure mapping (equine and bicycle), seating assessment, and
barefoot pedography, along with an interactive Shiny application for
data exploration.

> **Disclaimer.** `pressR` is not affiliated with novel GmbH.
> Product names (emed, pedar, pliance, loadsol) are trademarks of
> novel GmbH, used here for identification purposes only.

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
* **Predefined layouts** for pedar, emed, pliance mats (16x16 / 32x32),
  horse and bicycle saddles, wheelchair / car / office seating, and
  glove sensors.
* **Per-frame and per-trial analysis**: peak pressure, mean pressure,
  force, contact area, pressure-time integral, centre of pressure,
  symmetry index, gait cycle detection, and COP rollover pattern.
* **Application-specific analysis**: saddle bridge and slip detection,
  wheelchair hotspot identification, plantar-pressure regional analysis.
* **Published reference thresholds** for saddle fit (von Peinen 2010,
  Moenkemoeller 2005, Werner 2002), diabetic foot risk, and wheelchair
  seating.
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
