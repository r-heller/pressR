# Saddle Fit Reference Thresholds

Returns published threshold values for equine saddle pressure assessment
based on peer-reviewed studies.

## Usage

``` r
pr_ref_saddle(source = c("vonpeinen2010", "monkemoller2005", "werner2002"))
```

## Arguments

- source:

  Character. Reference source: `"vonpeinen2010"` (default),
  `"monkemoller2005"`, or `"werner2002"`.

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with columns `region`, `parameter`, `threshold`, `unit`,
`interpretation`, `source`.

## Examples

``` r
pr_ref_saddle()
#> # A tibble: 6 × 6
#>   region  parameter threshold unit  interpretation                        source
#>   <chr>   <chr>         <dbl> <chr> <chr>                                 <chr> 
#> 1 cranial mpp            34.5 kPa   Threshold above which back pain has … von P…
#> 2 middle  mpp            30.3 kPa   Threshold above which back pain has … von P…
#> 3 caudal  mpp            31   kPa   Threshold above which back pain has … von P…
#> 4 cranial mvp            13.2 kPa   Threshold above which back pain has … von P…
#> 5 middle  mvp            11.4 kPa   Threshold above which back pain has … von P…
#> 6 caudal  mvp            10   kPa   Threshold above which back pain has … von P…
```
