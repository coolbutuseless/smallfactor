% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pack.R
\name{pack_ints}
\alias{pack_ints}
\title{Pack an unbounded vector of small integers into 'nbit' values inside a a vector of 32bit integers}
\usage{
pack_ints(small_ints, nbits)
}
\arguments{
\item{small_ints}{vector of small integer values. these are recycle if necessary}

\item{nbits}{number of bits we want to pack these into}
}
\value{
vector of integer values
}
\description{
Pack an unbounded vector of small integers into 'nbit' values inside a a vector of 32bit integers
}
