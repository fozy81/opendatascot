test_that("get_ods works", {
  skip("work in progress - can't test - needs keyboard input")

  search <- ods_search("bike")
  data <- ods_get(search[1, ])
  data <- ods_get(search[1, ], refresh = TRUE)
  expect_message(ods_get(search = "sefafaa"))
  test <- ods_get(search = "bins")
})

test_that("get_ods validation works", {
  search <- ods_search("awdawawdd")
  expect_error(ods_get(search))
  expect_error(ods_get("awdawdawda"))
  expect_message(ods_get(search = "sefafaa"))
  expect_error(ods_get(data.frame()))
  expect_error(ods_get(data.frame("test" = c(1, 2, 3))))
})
