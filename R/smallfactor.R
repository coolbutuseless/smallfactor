

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Subset a smallfactor
#'
#' @param x smallfactor
#' @param ... ignored
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
'[.smallfactor' <- function(x, ...) {
  y <- NextMethod("[[")
  attr(y, "levels") <- attr(x, "levels")
  class(y) <- oldClass(x)
  y
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Include a smallfactor in a data.frame object
#'
#' @param x,row.names,optional,...,nm see documentation for \code{as.data.frame.faactor()}
#'
#' @return data.frame
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.data.frame.smallfactor <- function (x, row.names = NULL, optional = FALSE, ..., nm = deparse1(substitute(x))) {
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
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert an ordinary factor into a smallfactor
#'
#' @param x factor object
#'
#' @return smallfactor object if number of levels < 256, otherwise error
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.smallfactor <- function(x) {
  stopifnot(`only factor objects supported for now` = is.factor(x))
  stopifnot(length(levels(x)) < 256)

  smallfactor(x, levels = levels(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a smallfactor into a regular factor
#'
#' @param x smallfactor object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.factor.smallfactor <- function(x) {
  factor(as.integer(x), levels = seq.int(length(levels(x))), labels = levels(x))
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Character representation of a small factor
#'
#' @param x smallfactor object
#' @param ... other arguments passed to \code{as.character.factor()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
as.character.smallfactor <- function(x, ...) {
  as.character(as.factor.smallfactor(x), ...)
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Print a smallfactor
#'
#' @param x smallfactor object
#' @param ... other arguments passed to \code{print.factor()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print.smallfactor <- function(x, ...) {
  cat("[smallfactor]\n")
  print(as.factor.smallfactor(x), ...)
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Create a smallfactor i.e. a factor backed by a raw byte vector, not an integer
#'
#' @param x object to turn into a factor
#' @param levels the levels of the factor. Default: NULL means to take the
#'        level names from the given object
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
smallfactor <- function(x, levels = NULL) {

  stopifnot(length(unique(x)) < 256)

  if (is.null(levels)) {
    y      <- unique(x)
    ind    <- order(y)
    levels <- unique(as.character(y)[ind])
  }

  x <- as.character(x)
  f <- as.raw(match(x, levels))
  attr(f, 'levels') <- levels

  class(f) <- c('smallfactor')
  f
}

