context('testapp support functions')

test_that('NA2x works on vectors', {
  expect_that(NA2F(c(TRUE, TRUE, NA, FALSE)), equals(c(TRUE, TRUE, FALSE, FALSE)))
  expect_that(NA20(c(1, 618, NA, 33.9)), equals(c(1, 618, 0, 33.9)))
  expect_that(NA2Inf(c(-1, 0, NA, 1)), equals(c(-1, 0, Inf, 1)))
  expect_that(NA2mean(c(1,2,NA,4,5)), equals(c(1,2,3,4,5)))
})

test_that('NA2x works with singular and null cases', {
  expect_that(NA2F(NA), equals(FALSE))
  expect_that(NA2F(logical(0)), equals(logical(0)))
  expect_that(NA20(NA), equals(0))
  expect_that(NA20(numeric(0)), equals(numeric(0)))
  expect_that(NA2Inf(NA), equals(Inf))
  expect_that(NA2Inf(numeric(0)), equals(numeric(0)))
  expect_that(NA2mean(as.numeric(NA)), equals(NaN))
  expect_that(NA2mean(numeric(0)), equals(numeric(0)))
})

test_that('NA2x works on lists', {
  expect_that(NA2F(list('abc', 1, NA)), equals(list('abc', 1, FALSE)))
  expect_that(NA20(list(3)), equals(list(3)))
  expect_that(NA20(list(NA)), equals(list(0)))
  expect_that(NA2F(list()), equals(list()))
  expect_that(NA2mean(list('abc', 1, NA)), throws_error())
})

test_that('NA2x does reasonable things with mixed types', {
  expect_that(NA2F(c(1,2,3,NA)), equals(c(1,2,3,0)))
  expect_that(NA20(c(TRUE, FALSE, NA, TRUE)), equals(c(1, 0, 0, 1)))
  expect_that(NA2Inf(c("one", "two", "three", NA)), equals(c("one", "two", "three", "Inf")))
})