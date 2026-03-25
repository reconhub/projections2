# Merge a list of projections objects

This function merges \`projections\` objects, binding them by columns,
making sure that they all use the same dates, adding rows of '0' where
needed.

## Usage

``` r
merge_projections(x)
```

## Arguments

- x:

  A \`list\` of \`projections\` objects to be merged.

## Author

Thibaut Jombart

## Examples

``` r
## generate toy data
dates <- Sys.Date() + c(0, 0, 2, 5, 6, 6, 7)
i <- incidence::incidence(dates)
si <- c(0.2, 0.5, 0.2, 0.1)
R0 <- 3.5

## make several projections objects
x <- lapply(1:10,
            function(j)
              project(x = i,
                      si = si,
                      R = R0,
                      n_sim = 2 * j,
                      R_fix_within = TRUE,
                      n_days = j,
                      model = "poisson"
                      ))
## see all dimensions
lapply(x, dim)
#> [[1]]
#> [1] 1 2
#> 
#> [[2]]
#> [1] 2 4
#> 
#> [[3]]
#> [1] 3 6
#> 
#> [[4]]
#> [1] 4 8
#> 
#> [[5]]
#> [1]  5 10
#> 
#> [[6]]
#> [1]  6 12
#> 
#> [[7]]
#> [1]  7 14
#> 
#> [[8]]
#> [1]  8 16
#> 
#> [[9]]
#> [1]  9 18
#> 
#> [[10]]
#> [1] 10 20
#> 
merge_projections(x)
#> 
#> /// Incidence projections //
#> 
#>   // class: projections, matrix, array
#>   // 10 dates (rows); 110 simulations (columns)
#> 
#>  // first rows/columns:
#>            sim_1 sim_2 sim_3 sim_4 sim_5 sim_6
#> 2026-04-02     4     6     4     2     6     5
#> 2026-04-03     0     0     6    10     6     5
#> 2026-04-04     0     0     0     0     0     0
#> 2026-04-05     0     0     0     0     0     0
#>  .
#>  .
#>  .
#> 
#>  // dates:
#>  [1] "2026-04-02" "2026-04-03" "2026-04-04" "2026-04-05" "2026-04-06"
#>  [6] "2026-04-07" "2026-04-08" "2026-04-09" "2026-04-10" "2026-04-11"
#> 
```
