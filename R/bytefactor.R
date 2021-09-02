

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Subset a bytefactor
#'
#' @param x bytefactor
#' @param ... ignored
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'[.bytefactor' <- function(x, ...) {
  y <- NextMethod("[[")
  attr(y, "levels") <- attr(x, "levels")
  class(y) <- oldClass(x)
  y
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Include a bytefactor in a data.frame object
#'
#' Code based on \code{as.data.frame.numeric}
#'
#' @param x,row.names,optional,...,nm see documentation for \code{as.data.frame.faactor()}
#'
#' @return data.frame
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.data.frame.bytefactor <- function (x, row.names = NULL, optional = FALSE, ..., nm = deparse1(substitute(x))) { # nocov start
  force(nm)
  nrows <- length(x)
  if (!(is.null(row.names) || (is.character(row.names) && length(row.names) ==
                               nrows))) {
    warning(gettextf("'row.names' is not a character vector of length %d -- omitting it. Will be an error!",
                     nrows), domain = NA)
    row.names <- NULL
  }
  if (is.null(row.names)) {
    if (nrows == 0L)
      row.names <- character()
    else if (length(row.names <- names(x)) != nrows || anyDuplicated(row.names))
      row.names <- .set_row_names(nrows)
  }
  if (!is.null(names(x)))
    names(x) <- NULL
  value <- list(x)
  if (!optional)
    names(value) <- nm
  structure(value, row.names = row.names, class = "data.frame")
} # nocov end


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an ordinary factor into a bytefactor
#'
#' @param x factor object
#'
#' @return bytefactor object if number of levels < 256, otherwise error
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.bytefactor <- function(x) {
  stopifnot(`only factor objects supported for now` = is.factor(x))
  stopifnot(length(levels(x)) < 256)

  bytefactor(x, levels = levels(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a bytefactor into a regular factor
#'
#' @param x bytefactor object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.factor.bytefactor <- function(x) {
  factor(as.integer(unclass(x)), levels = seq.int(length(levels(x))), labels = levels(x))
  # factor(as.integer(unclass(x)), levels = levels(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Other representations of a small factor
#'
#' @param x bytefactor object
#' @param ... other arguments passed to \code{as.character.factor()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.character.bytefactor <- function(x, ...) {
  as.character(as.factor.bytefactor(x), ...)
}

#' @rdname as.character.bytefactor
#' @export
as.integer.bytefactor <- function(x, ...) {
  as.integer(as.factor.bytefactor(x), ...)
}

#' @rdname as.character.bytefactor
#' @export
as.double.bytefactor <- function(x, ...) {
  as.double(as.factor.bytefactor(x), ...)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Print a bytefactor
#'
#' @param x bytefactor object
#' @param ... other arguments passed to \code{print.factor()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.bytefactor <- function(x, ...) {
  cat("[bytefactor]\n")
  print(as.factor.bytefactor(x), ...)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a bytefactor i.e. a factor backed by a raw byte vector, not an integer
#'
#' @param x object to turn into a factor
#' @param levels the levels of the factor. Default: NULL means to take the
#'        level names from the given object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bytefactor <- function(x, levels = NULL) {

  stopifnot(length(unique(x)) < 256)

  if (is.null(levels)) {
    y      <- unique(x)
    ind    <- order(y)
    levels <- unique(as.character(y)[ind])
  }

  x <- as.character(x)
  f <- as.raw(match(x, levels))
  attr(f, 'levels') <- levels

  class(f) <- c('bytefactor')
  f
}

