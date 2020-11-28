test_that("get_accounts works", {
  skip("skip test on Github Action")
  expect_type(get_accounts(), "list")
})
