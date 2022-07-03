test_that("search_ods works", {
  search <- search_ods()
  testthat::expect_equal(class(search), c("tbl_df", "tbl", "data.frame"))
})
