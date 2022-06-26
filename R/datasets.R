#' Datasets
#' @param search Case-sensitive search term to fitler datasets. By default will return all
#'   datasets.
#' @return dataframe of available datasets (matching search term if provided).
#' @export
#'
#' @examples
#' data <- datasets(search = "bicycle") # search datasets
#' data <- datasets() # return all datasets
datasets <- function(search = "") {
  stopifnot(class(search) == "character")
  datasets <- jsonlite::fromJSON("https://opendata.scot/datasets.json",
    flatten = TRUE
  )
  datasets <- datasets[grep(search, datasets$title), ]
  datasets <- tibble::tibble(datasets)
  return(datasets)
}
