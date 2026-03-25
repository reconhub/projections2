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
#>         dates mean        sd min max quantiles.2.5% quantiles.25% quantiles.50%
#> 1  2020-01-24  0.5 0.7071068   0   1          0.025          0.25           0.5
#> 2  2020-01-25  1.0 0.0000000   1   1          1.000          1.00           1.0
#> 3  2020-01-26  1.5 0.7071068   1   2          1.025          1.25           1.5
#> 4  2020-01-27  1.0 0.0000000   1   1          1.000          1.00           1.0
#> 5  2020-01-28  3.5 3.5355339   1   6          1.125          2.25           3.5
#> 6  2020-01-29  3.5 2.1213203   2   5          2.075          2.75           3.5
#> 7  2020-01-30  3.0 2.8284271   1   5          1.100          2.00           3.0
#> 8  2020-01-31  6.0 4.2426407   3   9          3.150          4.50           6.0
#> 9  2020-02-01  7.5 6.3639610   3  12          3.225          5.25           7.5
#> 10 2020-02-02 14.0 8.4852814   8  20          8.300         11.00          14.0
#>    quantiles.75% quantiles.97.5%
#> 1           0.75           0.975
#> 2           1.00           1.000
#> 3           1.75           1.975
#> 4           1.00           1.000
#> 5           4.75           5.875
#> 6           4.25           4.925
#> 7           4.00           4.900
#> 8           7.50           8.850
#> 9           9.75          11.775
#> 10         17.00          19.700
```
