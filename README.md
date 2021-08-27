
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smallfactor - store factors in `raw` rather than `integer`

<!-- badges: start -->

![](https://img.shields.io/badge/cool-useless-green.svg)
<!-- badges: end -->

`smallfactor` is an experiment to see what tradeoffs there might be for
storing a factor in a raw byte instead of an integer.

Since an R `raw` value is only a single byte, but an `integer` is 4
bytes, there are space saving for large factors if stored in `raw`
vector - as long as the number of levels is less than 256.

## What’s in the box

-   `smallfactor()` - similar to `factor()`, but creates an object
    backed by raw bytes rather than an integer.

## Limitations

This package includes creating an object of the `smallfactor` class, and
includes a few expected methods for common usage
e.g. `as.character.smallfactor()`, `as.data.frame.smallfactor()`.

It seems possible that you could write more methods to make
`smallfactor` behaviour almost identical to regular `factor` behaviour,
but this package is not attempting this (yet).

## Installation

You can install from
[GitHub](https://github.com/coolbutuseless/smallfactor) with:

``` r
# install.package('remotes')
remotes::install_github('coolbutuseless/smallfactor')
```

## Example simple usage

``` r
small <- smallfactor(c('a', 'b', 'c', 'a', 'd'))
small
```

    #> [smallfactor]
    #> [1] a b c a d
    #> Levels: a b c d

``` r
small[1:3]
```

    #> [smallfactor]
    #> [1] a b c
    #> Levels: a b c d

``` r
df <- data.frame(value = small, y = 1:5)
df
```

    #>   value y
    #> 1     a 1
    #> 2     b 2
    #> 3     c 3
    #> 4     a 4
    #> 5     d 5

``` r
library(dplyr)
df %>%
  filter(value < 3)
```

    #>   value y
    #> 1     a 1
    #> 2     b 2
    #> 3     a 4

## Example - storing some DNA in 1/4 the space of a regular factor

``` r
library(smallfactor)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate some random DNA
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
dna <- sample(c('A', 'T', 'G', 'C'), 1e6, replace = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create a `factor` and a `smallfactor` using the same basic syntax
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
small   <- smallfactor(dna, levels = c('A', 'T', 'G', 'C'))
regular <- factor     (dna, levels = c('A', 'T', 'G', 'C'))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# `smallfactor` is approx 1/4 the size of the regular factor
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lobstr::obj_size(dna)
```

    #> 8,000,272 B

``` r
lobstr::obj_size(regular)
```

    #> 4,000,688 B

``` r
lobstr::obj_size(small)
```

    #> 1,000,696 B

## Acknowledgements

-   R Core for developing and maintaining the language.
-   CRAN maintainers, for patiently shepherding packages onto CRAN and
    maintaining the repository
