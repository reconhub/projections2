# Constructor for projections objects

This function builds a valid `projections` object from some input
simulations and dates.

## Usage

``` r
build_projections(x, dates = NULL, cumulative = FALSE, order_dates = TRUE)
```

## Arguments

- x:

  A `matrix` of simulated incidence stored as integers, where rows
  correspond to dates and columns to simulations.

- dates:

  A vector of dates containing one value per row in `x`; acceptable
  formats are: `integer`, `Date`, and `POSIXct`; if NULL, the time steps
  will be counted, with the first dates corresponding to 0.

- cumulative:

  A logical indicating if data represent cumulative incidence; defaults
  to `FALSE`.

- order_dates:

  A logical indicating whether the dates should be ordered, from the
  oldest to the most recent one; \`TRUE\` by default.

## See also

the
[`project`](http://www.repidemicsconsortium.org/projections2/reference/project.md)
function to generate the 'projections' objects.

## Author

Thibaut Jombart <thibautjombart@gmail.com>
