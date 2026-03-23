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
#> 2  2020-01-25  1.0  1.4142136   0   2          0.050          0.50
#> 3  2020-01-26  0.0  0.0000000   0   0          0.000          0.00
#> 4  2020-01-27  3.0  4.2426407   0   6          0.150          1.50
#> 5  2020-01-28  2.0  1.4142136   1   3          1.050          1.50
#> 6  2020-01-29  3.5  4.9497475   0   7          0.175          1.75
#> 7  2020-01-30  3.0  4.2426407   0   6          0.150          1.50
#> 8  2020-01-31  8.0  8.4852814   2  14          2.300          5.00
#> 9  2020-02-01 10.5 13.4350288   1  20          1.475          5.75
#> 10 2020-02-02 11.5 12.0208153   3  20          3.425          7.25
#>    quantiles.50% quantiles.75% quantiles.97.5%
#> 1            0.5          0.75           0.975
#> 2            1.0          1.50           1.950
#> 3            0.0          0.00           0.000
#> 4            3.0          4.50           5.850
#> 5            2.0          2.50           2.950
#> 6            3.5          5.25           6.825
#> 7            3.0          4.50           5.850
#> 8            8.0         11.00          13.700
#> 9           10.5         15.25          19.525
#> 10          11.5         15.75          19.575
```
