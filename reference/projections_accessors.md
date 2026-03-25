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
#> > dat <- c(0, 2, 2, 3, 3, 5, 5, 5, 6, 6, 6, 6)
#> > i <- incidence(dat)
#> > si <- distcrete("gamma", interval = 1L, shape = 1.5, scale = 2, w = 0)
#> > pred_1 <- project(i, 1.2, si, n_days = 30)
#> > pred_1
#> 
#> /// Incidence projections //
#> 
#>   // class: projections, matrix, array
#>   // 30 dates (rows); 100 simulations (columns)
#> 
#>  // first rows/columns:
#>    [,1] [,2] [,3] [,4] [,5] [,6]
#> 7     1    5    7    6    2    2
#> 8     5    0    2    6    2    3
#> 9     4    2    6    3    2    4
#> 10    7    7    5    3    3    2
#>  .
#>  .
#>  .
#> 
#>  // dates:
#>  [1]  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#> [26] 32 33 34 35 36
#> 
#> > get_dates(pred_1)
#>  [1]  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#> [26] 32 33 34 35 36
#> > max(i$dates)
#> [1] 6
```
