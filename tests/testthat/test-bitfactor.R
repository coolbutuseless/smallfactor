



test_that("bitfactor works", {


  x <- bitfactor(1:10)
  expect_true(inherits(x, 'bitfactor'))

  expect_length(x, 10)

  expect_equal(as.integer(x), 1:10)


  expect_equal(
    x[1:5],
    bitfactor(1:5, levels = as.character(1:10))
  )

  capture_output(
  expect_true(
    {print(x); as.character(x); TRUE}
  )
  )

  x0 <- factor(1:10)
  x1 <- as.bitfactor(x0)
  expect_equal(
    x1,
    x
  )

  expect_equal(
    as.double(x),
    1:10
  )

})
