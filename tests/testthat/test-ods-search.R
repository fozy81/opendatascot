test_that("search_ods works", {
  search <- ods_search()
  expect_equal(class(search), c("tbl_df", "tbl", "data.frame"))
})


test_that("search_ods validation works", {
  expect_message(ods_search("seawdaaww"))
  expect_error(ods_search(1))
})

test_that("search_ods multiple search terms works", {
  expect_message(ods_search(c("awdaaawd", "bike")))
  test <- ods_search(c("bi", "bin"))
  expect_true(all(duplicated(test$unique_id) == FALSE))
})


test <- ods_search(c("awdawd", "bike"))
