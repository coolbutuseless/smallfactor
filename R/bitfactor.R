

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Subset a bitfactor
#'
#' ToDo: This currently converts the entire bitfactor into a regular R
#' factor, subsets that R factor, then converts the subset back into a
#' bitfactor.   This is horribly inefficient, and should really just extract
#' the values being asked for.
#'
#' @param x bitfactor
#' @param y subset spedification
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"[.bitfactor" <- function(x, y) {
  as.bitfactor(as.factor.bitfactor(x)[y])
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a bitfactor to a factor
#'
#' @param x bitfactor
#' @param ... ignored
#'
#' @return standard R factor
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.factor.bitfactor <- function(x, ...) {
  nbits  <- attr(x,  'nbits', exact = TRUE)
  N      <- attr(x,      'N', exact = TRUE)
  levels <- attr(x, 'levels', exact = TRUE)

  small_ints <- unpack_ints(x, nbits = nbits) + 1L
  factor(levels[small_ints], levels = levels)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' convert bitfactor to integer, numeric and character
#'
#' @inheritParams as.factor.bitfactor
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.integer.bitfactor <- function(x, ...) {
  as.integer(as.factor.bitfactor(x))
}

#' @rdname as.integer.bitfactor
#' @export
as.double.bitfactor <- function(x, ...) {
  as.double(as.factor.bitfactor(x))
}

#' @rdname as.integer.bitfactor
#' @export
as.character.bitfactor <- function(x, ...) {
  as.character(as.factor.bitfactor(x))
}

#' @rdname as.integer.bitfactor
#' @export
length.bitfactor <- function(x, ...) {
  attr(x, 'N', exact = TRUE)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a standard factor to a bitfactor
#'
#' @param x factor object
#'
#' @return bitfactor object
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.bitfactor <- function(x) {
  stopifnot(`only conversion from factors currently supported` = is.factor(x))

  bitfactor(as.character(x), levels(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Print a bitfactor
#'
#' @inheritParams as.factor.bitfactor
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.bitfactor <- function(x, ...) {
  nbits  <- attr(x,  'nbits', exact = TRUE)
  N      <- attr(x,      'N', exact = TRUE)
  cat("[bitfactor] ", N, " values @ ~", nbits,
      " bits/value = ", length(unclass(x)) , " integer(s)\n", sep = "")
  print(as.factor.bitfactor(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a bitfactor
#'
#' @param x something coercile into a character vector
#' @param levels named levels.  This should probably just come from the
#'        values on 'x'.
#'
#' @return bitfactor object
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bitfactor <- function(x, levels = NULL) {

  # 15bits is the maximum sensible number of levels to store in a bit factor.
  # Any larger than 15 bits, and you can only fit 1 value per integer,
  # in which case you should just use a normal R factor.
  stopifnot(length(unique(x)) < 32768) # 2^15

  if (is.null(levels)) {
    y      <- unique(x)
    ind    <- order(y)
    levels <- unique(as.character(y)[ind])
  }

  x <- as.character(x)
  f <- match(x, levels) - 1L   # start at 0, rather than R's 1-indexing

  nbits <- as.integer(ceiling(log2(length(levels))))

  ints <- pack_ints(f, nbits)

  attr(ints, 'levels') <- levels
  attr(ints, 'nbits' ) <- nbits

  class(ints) <- c('bitfactor')
  ints
}



if (FALSE) {
  ints   <- c(1, 69, 255, 3, 10, 11, 12, 199, 257)

  z1 <- pack_ints(ints, nbits = 8)
  unpack_ints(z1, nbits = 8)

  orig <- sample(letters, 120, replace = TRUE)
  orig
  x <- bitfactor(orig, levels = letters)

}


