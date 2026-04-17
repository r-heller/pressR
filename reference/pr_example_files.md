# Write Sample Pressure Data Files

Creates sample ASCII files mimicking the novel export format in a
temporary directory, for demonstrating the parser functions.

## Usage

``` r
pr_example_files(type = c("pedar", "saddle", "emed", "all"))
```

## Arguments

- type:

  Character. `"pedar"` (default), `"saddle"`, `"emed"`, or `"all"`.

## Value

Character. Path to the sample file (single type) or directory (`"all"`).

## Examples

``` r
path <- pr_example_files("pedar")
file.exists(path)
#> [1] TRUE
```
