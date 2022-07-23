#' Datasets
#' @param search A case insensitive search term to fitler datasets. By default
#'   will return all datasets.
#' @return dataframe of available datasets (matching search term if provided).
#' @export
#' @importFrom rlang .data
#' @importFrom purrr map_dfr
#' @importFrom tibble as_tibble
#' @examples
#' data <- search_ods() # return ALL datasets
#' data <- search_ods(search = "bicycle") # search datasets
search_ods <- function(search = "") {
  stopifnot(class(search) == "character")
  datasets <- jsonlite::fromJSON("https://opendata.scot/datasets.json",
    flatten = TRUE
  )
  search_dfr <- map_dfr(search, function(search) {
    datasets <- datasets[grep(tolower(search), tolower(datasets$title)), ]

    datasets <- dplyr::mutate(datasets, unique_id = paste(
      .data$title,
      .data$organization
    ))
    datasets$unique_id <- gsub("[^A-Za-z0-9._-]", "_",
      datasets$unique_id,
      perl = TRUE
    )
    datasets <- dplyr::select(datasets, .data$unique_id, tidyr::everything())
    datasets <- tibble::tibble(datasets)
    if (nrow(datasets) == 0) {
      message(paste0(
        "You searched for: `",
        search,
        "`. No dataset titles contain that search term"
      ))
    }
    return(datasets)
  })
  search_dfr <- unique(search_dfr)
  search_dfr <- as_tibble(search_dfr)
  return(search_dfr)
}
