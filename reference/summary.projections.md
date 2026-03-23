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
#> 1  2020-01-24  2.5  0.7071068   2   3          2.025          2.25
#> 2  2020-01-25  3.0  0.0000000   3   3          3.000          3.00
#> 3  2020-01-26  4.0  1.4142136   3   5          3.050          3.50
#> 4  2020-01-27  7.5  0.7071068   7   8          7.025          7.25
#> 5  2020-01-28  7.0  2.8284271   5   9          5.100          6.00
#> 6  2020-01-29 16.0  8.4852814  10  22         10.300         13.00
#> 7  2020-01-30 17.0  9.8994949  10  24         10.350         13.50
#> 8  2020-01-31 28.0 21.2132034  13  43         13.750         20.50
#> 9  2020-02-01 38.0 22.6274170  22  54         22.800         30.00
#> 10 2020-02-02 58.5 30.4055916  37  80         38.075         47.75
#>    quantiles.50% quantiles.75% quantiles.97.5%
#> 1            2.5          2.75           2.975
#> 2            3.0          3.00           3.000
#> 3            4.0          4.50           4.950
#> 4            7.5          7.75           7.975
#> 5            7.0          8.00           8.900
#> 6           16.0         19.00          21.700
#> 7           17.0         20.50          23.650
#> 8           28.0         35.50          42.250
#> 9           38.0         46.00          53.200
#> 10          58.5         69.25          78.925
```
