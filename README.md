
<!-- README.md is generated from README.Rmd. Please edit that file -->

# smallfactor - store factors in bytes and bits rather than an `integer`

<!-- badges: start -->

![](https://img.shields.io/badge/cool-useless-green.svg)
[![R-CMD-check](https://github.com/coolbutuseless/smallfactor/workflows/R-CMD-check/badge.svg)](https://github.com/coolbutuseless/smallfactor/actions)
<!-- badges: end -->

`smallfactor` is an experiment to see what trade-offs there might be for
storing a factor in bytes or bits instead of an integer.

An R integer is 4-bytes, meaning it could hold a factor with two billion
levels, which seems like overkill.

`bytefactor` targets factors with up to 256 levels.

`bitfactor` will choose the fewest bits to store a factor for factors
with 2 up to 32768 (2^15) levels.

## What’s in the box

-   `bytefactor()` store factor values in raw bytes rather than an
    integer.
-   `bitfactor()` store factor values as bits within integers - with
    multiple factors stored in a single integer value. E.g. a factor
    with 4 levels could be stored as just 2 bits of information, meaning
    16 values could be stored in a single R integer (16 \* 2 bits = 32
    bits = 4 bytes)

## Limitations

It seems possible that you could write more methods to make these
smaller factors behave similar to regular R `factor` objects, but this
package is not attempting this (yet).

Internally, there’s currently a lot of transferring back-and-forth
between these small factors and the standard R factor in order to make
use of the printing and subsetting capabilities of the R factor
implementation. Much of this back-and-forth could be avoided if effort
was expended to do so.

Note: `bitfactor` uses only 31 bits of a 32-bit integer in order to
avoid issues around `NA_integer_` representation. This means, for
example, that an integer can only hold 15 x 2-bit values. In practice
the user is never expected to notice this or care about it.

## Installation

You can install from
[GitHub](https://github.com/coolbutuseless/smallfactor) with:

``` r
# install.package('remotes')
remotes::install_github('coolbutuseless/smallfactor')
```

## `bytefactor`

``` r
small <- bytefactor(c('a', 'b', 'c', 'a', 'd'))
small
```

    #> [bytefactor]
    #> [1] a b c a d
    #> Levels: a b c d

``` r
small[1:3]
```

    #> [bytefactor]
    #> [1] a b c
    #> Levels: a b c d

## `bitfactor`

`bitfactor()` will choose an appropriate number of bits to store the
given number of levels.

In the following example, there are 4 levels, so `bitfactor()` chooses
to store each value in the factor in 2 bits.

``` r
tiny <- bitfactor(c('a', 'b', 'c', 'a', 'd'))
tiny
```

    #> [bitfactor] 5 values @ ~2 bits/value = 1 integer(s)
    #> [1] a b c a d
    #> Levels: a b c d

``` r
tiny[1:3]
```

    #> [bitfactor] 3 values @ ~2 bits/value = 1 integer(s)
    #> [1] a b c
    #> Levels: a b c d

In this next example, there are 100 levels in the factor, so 7 bits are
needed to fully store all the levels

``` r
tiny <- bitfactor(sample(100, 10), levels=1:100)
tiny
```

    #> [bitfactor] 10 values @ ~7 bits/value = 3 integer(s)
    #>  [1] 19  83  56  8   28  14  42  100 71  31 
    #> 100 Levels: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 ... 100

``` r
tiny[4:6]
```

    #> [bitfactor] 3 values @ ~7 bits/value = 1 integer(s)
    #> [1] 8  28 14
    #> 100 Levels: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 ... 100

## Storing some DNA in `bytefactor` and `bitfactor` objects.

|                | character | factor | bytefactor | bitfactor |
|----------------|-----------|--------|------------|-----------|
| bits/value     | 64        | 32     | 8          | 2         |
| total size     | 8 MB      | 4 MB   | 1 MB       | 270 kB    |
| size reduction |           | 2x     | 8x         | 30x       |

``` r
library(smallfactor)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Generate some random DNA
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
character_vector_dna <- sample(c('A', 'T', 'G', 'C'), 1e6, replace = TRUE)

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create a `factor` and a `smallfactor` using the same basic syntax
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
integer_factor <- factor    (character_vector_dna, levels = c('A', 'T', 'G', 'C'))
byte_factor    <- bytefactor(character_vector_dna, levels = c('A', 'T', 'G', 'C'))
bit_factor     <- bitfactor (character_vector_dna, levels = c('A', 'T', 'G', 'C'))

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# `smallfactor` is approx 1/4 the size of the regular factor
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lobstr::obj_size(character_vector_dna)
```

    #> 8,000,272 B

``` r
lobstr::obj_size(integer_factor)
```

    #> 4,000,688 B

``` r
lobstr::obj_size(byte_factor)
```

    #> 1,000,696 B

``` r
lobstr::obj_size(bit_factor)
```

    #> 267,704 B

## Similar projects

-   [{lofi}](https://github.com/coolbutuseless/lofi)

## Acknowledgements

-   R Core for developing and maintaining the language.
-   CRAN maintainers, for patiently shepherding packages onto CRAN and
    maintaining the repository
