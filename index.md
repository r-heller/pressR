# pressR

**pressR** parses, analyses, and visualises pressure distribution data
from capacitive sensor systems. It ships with predefined layouts, along
with an interactive Shiny application for data exploration.

## Installation

``` r
# install.packages("pak")
pak::pak("r-heller/pressR")
```

## Quick example

``` r
library(pressR)

trial <- pr_example_trial("pedar")

pr_plot_heatmap(trial)
pr_plot_force_time(trial, show_cycles = TRUE)

pr_summary(trial)
pr_calc_regional(trial)
```

## Features

- **Parsers** for novel ASCII exports, generic CSV, loadsol data, and
  novel mask files (`.msa`/`.msr`/`.msp`).
- **Per-frame and per-trial analysis**: peak pressure, mean pressure,
  force, contact area, pressure-time integral, centre of pressure,
  symmetry index, gait cycle detection, and COP rollover pattern.
- **Visualisation**: 2D and 3D heatmaps, dynamics plots, regional bar
  charts, composite report panels, and side-by-side trial comparison.
- **Shiny app**
  ([`pr_run_app()`](https://r-heller.github.io/pressR/reference/pr_run_app.md))
  for interactive import, analysis, and export.

## Vignettes

- [`vignette("getting-started", package = "pressR")`](https://r-heller.github.io/pressR/articles/getting-started.md)
- [`vignette("saddle-pressure-analysis", package = "pressR")`](https://r-heller.github.io/pressR/articles/saddle-pressure-analysis.md)
- [`vignette("foot-pressure-analysis", package = "pressR")`](https://r-heller.github.io/pressR/articles/foot-pressure-analysis.md)

## License

MIT © Raban Heller.
