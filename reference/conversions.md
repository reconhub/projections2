# Conversion of projections objects

These functions convert `projections` objects into other classes.

## Usage

``` r
# S3 method for class 'projections'
as.matrix(x, ...)

# S3 method for class 'projections'
as.data.frame(x, ..., long = FALSE)
```

## Arguments

- x:

  An `projections` object, or an object to be converted as `projections`
  (see details).

- ...:

  Further arguments passed to other functions (no used).

- long:

  A logical indicating if the output data.frame should be 'long', i.e.
  where a single column containing 'groups' is added in case of data
  computed on several groups.

## See also

the
[`project`](http://www.repidemicsconsortium.org/projections2/reference/project.md)
function to generate the 'projections' objects.

## Author

Thibaut Jombart <thibautjombart@gmail.com>
