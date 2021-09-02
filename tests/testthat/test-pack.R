



test_that("pack structure definitions", {

  expect_equal(base[[1]], 1L )
  expect_equal(base[[2]], 1L + 2L)
  expect_equal(base[[3]], 1L + 2L + 4L)


  expect_equal(
    shifts[[2]],
    seq.int(0, 31 - 2, 2)
  )

  expect_equal(
    shifts[[3]],
    seq.int(0, 31 - 3, 3)
  )

  expect_equal(
    shifts[[4]],
    seq.int(0, 31 -4 , 4)
  )

  expect_equal(
    shifts[[5]],
    seq.int(0, 31 - 5, 5)
  )


  expect_equal(
    masks[[2]],
    bitwShiftL(3,  seq(0, 31-2, 2))
  )

  expect_equal(
    masks[[3]],
    bitwShiftL(7,  seq.int(0, 31-3, 3))
  )

})



test_that("single int works", {

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  int <- pack_into_single_int(c(1, 2, 3, 4), nbits = 7)

  expect_equal(
    int,
    sum(
      bitwShiftL(1,  0),
      bitwShiftL(2,  7),
      bitwShiftL(3, 14),
      bitwShiftL(4, 21)
    )
  )

  res <- unpack_from_single_int(int, nbits = 7)
  expect_equal(res, c(1, 2, 3, 4))



  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  int <- pack_into_single_int(c(1, 2), nbits = 7)

  expect_equal(
    int,
    sum(
      bitwShiftL(1,  0),
      bitwShiftL(2,  7),
      bitwShiftL(1, 14),
      bitwShiftL(2, 21)
    )
  )

  res <- unpack_from_single_int(int, nbits = 7)
  expect_equal(res, c(1, 2, 1, 2))



  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  int <- pack_into_single_int(c(1, 2), nbits = 15)

  expect_equal(
    int,
    sum(
      bitwShiftL(1,  0),
      bitwShiftL(2, 15)
    )
  )

  res <- unpack_from_single_int(int, nbits = 15)
  expect_equal(res, c(1, 2))
})


test_that("multiple ints works", {
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ints <- pack_ints(c(1, 2, 3, 4, 5, 6, 7, 8), nbits = 8)
  res  <- unpack_ints(ints, nbits = 8)
  expect_equal(res, c(1, 2, 3, 4, 5, 6, 7, 8))
})


test_that("multiple ints stress test", {

  set.seed(2021)
  for (i in seq(200)) {
    N     <- sample(50, 1)
    nbits <- sample(1:15, 1)
    orig  <- sample(0:(2^nbits-1), N, replace = TRUE)
    ints  <- pack_ints(orig, nbits = nbits)
    res   <- unpack_ints(ints, nbits = nbits)
    expect_identical(res, orig)
  }

})








