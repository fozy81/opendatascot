#' Datasets
#' @param search A case insensitive search term to fitler datasets. By default
#'   will return all datasets.
#' @return dataframe of available datasets (matching search term if provided).
#' @export
#'
#' @examples
#' data <- search_ods(search = "bicycle") # search datasets
#' data <- search_ods() # return all datasets
search_ods <- function(search = "") {
  stopifnot(class(search) == "character")
  datasets <- jsonlite::fromJSON("https://opendata.scot/datasets.json",
    flatten = TRUE
  )
  datasets <- datasets[grep(tolower(search), tolower(datasets$title)), ]
  datasets <- tibble::tibble(datasets)
  return(datasets)
}
