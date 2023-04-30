#' Search Open Data Scot Datasets
#'
#' This function will return metadata associated with datasets available on
#' opendata.scot
#'
#' @param search A vector of search terms. Searches are performed on the title
#'   of the datasets and are case insensitive. If no search terms provided,
#'   metadata for all datasets will be returned.
#' @return dataframe of metadata for available datasets (matching search term if
#'   provided).
#' @export
#' @importFrom dplyr filter
#' @importFrom rlang .data
#' @importFrom purrr map_dfr
#' @importFrom tibble as_tibble
#' @examples
#' all_datasets <- search_ods() # return ALL datasets
#' data <- search_ods(search = "bicycle") # search datasets
#' data <- search_ods(search = c("bicycle","bins")) # multiple search terms
search_ods <- function(search = "") {
  stopifnot(class(search) == "character")
  datasets <- jsonlite::fromJSON("https://opendata.scot/datasets.json",
    flatten = TRUE
  )
  datasets <- filter(datasets, licence != "No licence")
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
