# Get pliance Sensor Mat Layout

Returns a
[pr_layout](https://r-heller.github.io/pressR/reference/pr_layout.md)
for a generic pliance sensor mat. pliance mats are general-purpose
capacitive pressure sensor arrays used in research, seating, sports, and
ergonomics.

## Usage

``` r
pr_layout_pliance(size = c("16", "32"))
```

## Arguments

- size:

  Character. `"16"` (default) for 16x16 = 256 sensors or `"32"` for
  32x32 = 1024 sensors.

## Value

A [pr_layout](https://r-heller.github.io/pressR/reference/pr_layout.md)
with no predefined regions.
