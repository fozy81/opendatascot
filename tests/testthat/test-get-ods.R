test_that("get_ods works", {
  skip("work in progress")

  search <- search_ods("bike")
  data <- get_ods(search)
  data <- get_ods(search, refresh = TRUE)
  expect_error(get_ods(search = "sefafaa"))
  test <- get_ods(search = "bins")
})

test_that("get_ods validation works", {
  search <- search_ods("awdawawdd")
  expect_error(get_ods(search))
  expect_error(get_ods("awdawdawda"))
  expect_error(get_ods(data.frame()))
  expect_error(get_ods(data.frame("test" = c(1, 2, 3))))
})
