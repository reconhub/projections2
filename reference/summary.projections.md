# Summary for projections objects

This method summarises predicted epidemic trajectories contained in a
\`projections\` object by days, deriving the mean, standard deviation,
and user-specified quantiles for each day.

## Usage

``` r
# S3 method for class 'projections'
summary(
  object,
  quantiles = c(0.025, 0.25, 0.5, 0.75, 0.975),
  mean = TRUE,
  sd = TRUE,
  min = TRUE,
  max = TRUE,
  ...
)
```

## Arguments

- object:

  A \`projections\` object to summarise

- quantiles:

  A \`numeric\` vector indicating which quantiles should be computed;
  ignored if \`FALSE\` or of length 0

- mean:

  a \`logical\` indicating of the mean should be computed

- sd:

  a \`logical\` indicating of the standard deviation should be computed

- min:

  a \`logical\` indicating of the minimum should be computed

- max:

  a \`logical\` indicating of the maximum should be computed

- ...:

  only preesnt for compatibility with the generic

## Author

Thibaut Jombart

## Examples

``` r
if (require(incidence)) {
  i <- incidence::incidence(as.Date('2020-01-23'))
  si <- c(0.2, 0.5, 0.2, 0.1)
  R0 <- 2

  p <- project(x = i,
               si = si,
               R = R0,
               n_sim = 2, 
               R_fix_within = TRUE,
               n_days = 10,
               model = "poisson"
               )
  summary(p)

}
#>         dates mean         sd min max quantiles.2.5% quantiles.25%
#> 1  2020-01-24  0.5  0.7071068   0   1          0.025          0.25
#> 2  2020-01-25  1.0  0.0000000   1   1          1.000          1.00
#> 3  2020-01-26  1.5  2.1213203   0   3          0.075          0.75
#> 4  2020-01-27  2.5  2.1213203   1   4          1.075          1.75
#> 5  2020-01-28  3.5  3.5355339   1   6          1.125          2.25
#> 6  2020-01-29  4.5  4.9497475   1   8          1.175          2.75
#> 7  2020-01-30  5.0  5.6568542   1   9          1.200          3.00
#> 8  2020-01-31  9.5  9.1923882   3  16          3.325          6.25
#> 9  2020-02-01 14.5 14.8492424   4  25          4.525          9.25
#> 10 2020-02-02 16.0 12.7279221   7  25          7.450         11.50
#>    quantiles.50% quantiles.75% quantiles.97.5%
#> 1            0.5          0.75           0.975
#> 2            1.0          1.00           1.000
#> 3            1.5          2.25           2.925
#> 4            2.5          3.25           3.925
#> 5            3.5          4.75           5.875
#> 6            4.5          6.25           7.825
#> 7            5.0          7.00           8.800
#> 8            9.5         12.75          15.675
#> 9           14.5         19.75          24.475
#> 10          16.0         20.50          24.550
```
