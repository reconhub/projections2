# Compute cumulative projections

`cumulate` is an S3 generic to compute cumulative numbers defined in the
package `incidence`. The method for `projections` objects turns
predicted incidences into cumulative incidences over time.

## Usage

``` r
# S3 method for class 'projections'
cumulate(x)
```

## Arguments

- x:

  A `projections` object.

## See also

The
[`project`](http://www.repidemicsconsortium.org/projections2/reference/project.md)
function to generate the `projections` objects.

## Author

Thibaut Jombart <thibautjombart@gmail.com>

## Examples

``` r
if (require(distcrete) &&
    require(incidence)) {

  ## simulate basic epicurve
  dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
  i <- incidence(dat)


  ## example with a function for SI
  si <- distcrete("gamma", interval = 1L,
                  shape = 1.5,
                  scale = 2, w = 0)
  set.seed(1)
  pred_1 <- project(i, runif(100, 0.8, 1.9), si, n_days = 30)
  plot_1 <- plot(pred_1)

  ## cumulative predictions
  pred_1_cum <- cumulate(pred_1)
  pred_1_cum
  plot(pred_1_cum)
}
#> Loading required package: distcrete
#> Warning: there is no package called ‘distcrete’

```
