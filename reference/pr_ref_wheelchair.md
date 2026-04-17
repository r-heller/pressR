# Wheelchair Seating Pressure Thresholds

Wheelchair Seating Pressure Thresholds

## Usage

``` r
pr_ref_wheelchair()
```

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with threshold values and sources.

## Examples

``` r
pr_ref_wheelchair()
#> # A tibble: 3 × 6
#>   region  parameter     threshold unit  interpretation                    source
#>   <chr>   <chr>             <dbl> <chr> <chr>                             <chr> 
#> 1 ischial mpp                  60 mmHg  Elevated ischial peak pressure (… Sprig…
#> 2 ischial mean_pressure        32 mmHg  Capillary closing pressure (Land… Landi…
#> 3 any     mpp                 200 mmHg  Very high focal pressure associa… Stins…
```
