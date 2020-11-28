test_that("get_token works", {
  skip("skip test on Github Action")
  expect_type(get_token(), "character")
})
