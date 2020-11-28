test_that("get_accounts works", {
  skip_on_cran()
  expect_type(get_accounts(), "list")
})
