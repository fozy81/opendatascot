#' Search Open Data Scot Datasets
#'
#' This function will return metadata associated with datasets available on
#' opendata.scot
#'
#' @param search A vector of search terms. Searches are performed on the title
#'   of the datasets and are case insensitive. If no search terms provided,
#'   metadata for all datasets will be returned.
#' @param refresh A boolean to download a fresh list of opendatascot datasets
#'   from opendata.scot. Default is FALSE, in which case a cached dataset will
#'   be used (except if first time using function). A message will appear if
#'   cached dataset is more than a week old.
#' @return dataframe of metadata for available datasets (matching search term if
#'   provided).
#' @export
#' @importFrom dplyr filter
#' @importFrom rlang .data
#' @importFrom purrr map_dfr
#' @importFrom tibble as_tibble
#' @importFrom jsonlite fromJSON
#' @examples
#' all_datasets <- ods_search() # return ALL datasets
#' data <- ods_search(search = "bicycle") # search datasets
#' data <- ods_search(search = c("bicycle", "bins")) # multiple search terms
ods_search <- function(search = "", refresh = FALSE) {
  stopifnot(class(search) == "character")
  dir <- opendatascot_dir()
  file_name <- "opendatascot_json"
  file_name <- paste0(file_name, ".rds")
  file_path <- file.path(dir, file_name)
  if (!file.exists(file_path) || refresh) {
    datasets <- fromJSON("https://opendata.scot/datasets.json",
      flatten = TRUE
    )
    datasets <- as_tibble(datasets)
    saveRDS(datasets, file_path)
  } else {
    datasets <- readRDS(file_path)
    time <- file.mtime(file_path)
    # If cached data greater than week (in mins units) - warn user to refresh
    if ((Sys.time() - time) > 10090) {
      warning(
        "The cached list of datasets from opendata.scot is more than 1-week-old
  - use `refresh=TRUE` to get the most recent update"
      )
    } else {
      message(paste(
        "The cached list of datasets from opendata.scot was last downloaded on",
        format(time, "%Y-%m-%d")
      ))
    }
  }
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
