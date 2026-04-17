# Diabetic Foot Pressure Thresholds

Clinical thresholds for plantar-pressure risk assessment in patients
with diabetic neuropathy.

## Usage

``` r
pr_ref_diabetic_foot()
```

## Value

A [tibble::tibble](https://tibble.tidyverse.org/reference/tibble.html)
with threshold values and sources.

## Examples

``` r
pr_ref_diabetic_foot()
#> # A tibble: 4 × 6
#>   region      parameter threshold unit  interpretation                    source
#>   <chr>       <chr>         <dbl> <chr> <chr>                             <chr> 
#> 1 any plantar mpp             200 kPa   Elevated ulceration risk (Armstr… Armst…
#> 2 any plantar pti_mean         70 kPa*s Pressure-time integral associate… Casel…
#> 3 forefoot    mpp             400 kPa   High-risk forefoot peak pressure… Veves…
#> 4 heel        mpp             250 kPa   Heel threshold reported in mixed… Frykb…
```
