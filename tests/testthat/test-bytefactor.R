

test_that("bytefactor works", {


  x <- bytefactor(1:10)
  expect_true(inherits(x, 'bytefactor'))

  expect_equal(as.integer(x), 1:10)

  df <- data.frame(x)
  expect_true(is.data.frame(df))

  expect_equal(
    x[1:5],
    bytefactor(1:5, levels = as.character(1:10))
  )

  capture_output(
  expect_true(
    {print(x); as.character(x); TRUE}
  )
  )

  x0 <- factor(1:10)
  x1 <- as.bytefactor(x0)
  expect_equal(
    x1,
    x
  )


  as.numeric(x)


})
