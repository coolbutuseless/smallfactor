

base <- lapply(
  1:15,
  function(nbits) {
    as.integer(sum(2 ^ seq.int(0, nbits-1)))
  }
)

shifts <- lapply(1:15, function(nbits) {
  (seq.int(31 %/% nbits) - 1L) * nbits
})

create_masks <- function(n) { # nocov start
  n      <- as.integer(n)
  b      <- base[[n]]
  ss     <- shifts[[n]]
  vapply(
    ss,
    function(shift) {
      bitwShiftL(b, shift)
    },
    integer(1)
  )
} # nocov end

masks <- lapply(1:15, create_masks)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Pack integer values into a single integer
#'
#' @param small_ints vector of small integer values. these are recycle if necessary
#' @param nbits number of bits we want to pack these into
#'
#' @return single integer value
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pack_into_single_int <- function(small_ints, nbits) {
  # ToDo: assert that length of small_ints matches expectations of 'nbits'
  # i.e. if nbits=16, then small_ints can only have a maximum of 2 values
  maxlen <- floor(31/nbits)
  stopifnot(length(small_ints) <= maxlen)

  shifted_small_ints <-
    bitwShiftL(
      bitwAnd(small_ints, base[[nbits]]),  # ensure bits are within range
      shifts[[nbits]]
    )

  sum(shifted_small_ints)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Unpacka an integer value into a vector of small integers of 'nbits' each
#'
#' @param int single integer value
#' @inheritParams pack_into_single_int
#'
#' @return vector of small integers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unpack_from_single_int <- function(int, nbits) {
  shifted_ints <- bitwAnd(int, masks[[nbits]])
  bitwShiftR(shifted_ints, shifts[[nbits]])
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Pack an unbounded vector of small integers into 'nbit' values inside a a vector of 32bit integers
#'
#' @inheritParams pack_into_single_int
#'
#' @return vector of integer values
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pack_ints <- function(small_ints, nbits) {
  N <- 31L %/% nbits
  chunks <- chunk(small_ints, N)
  res <- vapply(chunks, pack_into_single_int, integer(1), nbits = nbits)

  attr(res, 'N') <- length(small_ints)
  res
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Unpack a 32-bit integer values into a vector of small integers of 'nbits' each
#'
#' @param ints integer vector
#' @inheritParams unpack_from_single_int
#'
#' @return vector of small integers
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unpack_ints <- function(ints, nbits) {
  res <- unlist(lapply(ints, unpack_from_single_int, nbits = nbits))

  N <- attr(ints, 'N', exact = TRUE)
  if (!is.null(N)) {
    res <- res[seq.int(N)]
  }

  res
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Split a vector in chunks of size 'n'
#'
#' @param x vector
#' @param n chunk size
#'
#' @return list of vectors
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
chunk <- function(x, n) {
  N <- length(x)
  S <- seq.int(from=1L, to=N, by=n)
  mapply(
    function(a, b) {x[a:b]},
    S,
    pmin(S + (n - 1L), N),
    SIMPLIFY = FALSE
  )
}
