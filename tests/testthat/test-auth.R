test_that("get_token works", {
  skip_on_cran()
  expect_type(get_token(), "character")
})
