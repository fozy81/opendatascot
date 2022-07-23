#' Get Data
#'
#' Return matching data from https://opendata.scot/ API.
#'
#' @param data Dataframe from `search_ods()` or if default (NULL), will download
#'   all datasets.
#' @param search Search term(s) if `data` not provided, will use `search_ods()`
#'   to return a dataframe of matching datasets.
#' @param refresh Refresh cached data. If data has changed remotely, use this to
#'   update or renew corrupted data/cache. This will download data again and
#'   update cache.
#' @param ask If FALSE, user will not be prompted for input to download data.
#'   This is useful to automate data downloads and cache updated or speed up the
#'   process if downloading many datasets at once.
#'
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @return list of named data frames.
#' @export
#'
#' @examples
#' search <- search_ods("Number of bikes")
#' data <- get_ods(search, refresh = TRUE, ask = FALSE)
get_ods <- function(data = NULL,
                    search = NULL,
                    refresh = FALSE,
                    ask = TRUE) {
  if (is.null(data) & is.null(search)){
    message("data * search arguments are NULL, downloading all ods datasets!")
    data <- search_ods()
  }

  if (!is.null(data) & !is.null(search)){
    stop("You provided values to both data and search paramters, only one can be used")
  }

  if (!is.null(search)){
    data <- search_ods(search)
  }

  stopifnot("data must be a dataframe" = any(class(data) %in% "data.frame"))
  stopifnot("data must have more than one row" = nrow(data) != 0)
  stopifnot("data must have `unique_id` column" = !is.null(data$unique_id))

  output <- lapply(split(data, data$unique_id), function(dataset) {
    dir <- opendatascot_dir()
    file_name <- dataset$unique_id
    file_name <- paste0(file_name, ".rds")
    file_path <- file.path(dir, file_name)
    if (!file.exists(file_path) | refresh) {
      create_data_dir(dir, ask, dataset)
      dataset <- dplyr::select(dataset, .data$title, .data$resources)
      dataset <- tidyr::unnest(dataset, cols = "resources")
      dataset <- dplyr::filter(dataset, format == "CSV")
      if (nrow(dataset) < 1) {
        message("No datasets with CSV for download found,
                CSV is only the supported format currently")
        return()
      }
      url <- dataset$url[1]
      data <- readr::read_csv(url, show_col_types = FALSE)
      data <- as_tibble(data)
      wd <- getwd()
      td <- tempdir()
      setwd(td)
      data <- structure(data, time_downloaded = Sys.time())
      saveRDS(data, file_path)
      unlink(dir(td))
      setwd(wd)
    } else {
      data <- readRDS(file_path)
      time <- attributes(data)$time_downloaded
      message(paste0(
        "'",
        dataset$title, "' dataset was last downloaded on ",
        format(time, "%Y-%m-%d")
      ))
    }
    data
  })
  return(output)
}

create_data_dir <- function(dir, ask, dataset) {
  if (ask) {
    ans <- gtools::ask(paste("opendatascot would like to store: ",
      dataset$title, " dataset in the directory: ",
      dir, "Is that okay? Key '1' Go ahead",
      sep = "\n"
    ))
    if (ans != 1) {
      message(paste("No problem, skipping download: ", dataset$title))
      return(NULL)
    }
  }

  if (!dir.exists(dir)) {
    message("Creating directory to hold opendatascot data at ", dir)
    dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  } else {
    message("Saving to opendatascot data directory at ", dir)
  }
}

opendatascot_dir <- function() {
  getOption("openscotdata.data_dir",
    default = rappdirs::user_data_dir("opendatascot")
  )
}
