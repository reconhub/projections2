# Access content projections objects

These simple helper functions retrieve content from `projections`
objects. They currently include:

## Usage

``` r
# S3 method for class 'projections'
get_dates(x, ...)
```

## Arguments

- x:

  A `projections` object.

- ...:

  Further arguments passed to methods; currently not used.

## Details

- `get_dates`: get dates of the predictions.

## Author

Thibaut Jombart <thibautjombart@gmail.com>

## Examples

``` r

if (require(distcrete) && require(incidence)) { withAutoprint({

## prepare input: epicurve and serial interval
dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
i <- incidence(dat)
si <- distcrete("gamma", interval = 1L,
                 shape = 1.5,
                 scale = 2, w = 0)


## make predictions
pred_1 <- project(i, 1.2, si, n_days = 30)
pred_1


## retrieve content
get_dates(pred_1)
max(i$dates) # predictions start 1 day after last incidence

})}
#> Loading required package: distcrete
#> Warning: there is no package called ‘distcrete’
```
