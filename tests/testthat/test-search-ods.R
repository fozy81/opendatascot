test_that("search_ods works", {
  search <- search_ods()
  expect_equal(class(search), c("tbl_df", "tbl", "data.frame"))
})


test_that("search_ods validation works", {
  expect_message(search_ods("seawdaaww"))
  expect_error(search_ods(1))
})

test_that("search_ods multiple search terms works", {
  expect_message(search_ods(c("awdaaawd", "bike")))
  test <- search_ods(c("bi", "bin"))
  expect_true(all(duplicated(test$unique_id) == FALSE))
})


test <- search_ods(c("awdawd", "bike"))
