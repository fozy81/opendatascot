#' Get Data
#'
#' Search and return matching datasets from https://opendata.scot/ API.
#'
#' @param search Search term
#' @param refresh Refresh cached data. If data has changed remotely, use this to
#'   update or renew corrupted data/cache. This will download data again and
#'   update cache.
#' @param ask If FALSE, user will not be prompted for input to download data.
#'   This is useful to automate data downloads and cache updated or speed up the
#'   process if downloading many datasets at once.
#'
#' @return
#' @export
#'
#' @examples
get_data <- function(search = "",
                     refresh = FALSE,
                     ask = TRUE) {
  datasets <- datasets(search = search)
  if (nrow(datasets) < 1) {
    message("No datasets matching that title found")
    return()
  }
  output <- lapply(split(datasets, datasets$title), function(dataset) {
    dir <- opendatascot_dir()
    file_name <- paste0(dataset$title, ".rds")
    file_path <- file.path(dir, file_name)
    if (!file.exists(file_path) | refresh) {
      create_data_dir(dir, ask, dataset)
      dataset <- dplyr::select(dataset, title, resources)
      dataset <- tidyr::unnest(dataset, cols = "resources")
      dataset <- dplyr::filter(dataset, format == "CSV")
      if (nrow(dataset) < 1) {
        message("No datasets with CSV for download found
                (CSV is only the support format currently)")
        return()
      }
      url <- dataset$url[1]
      data <- readr::read_csv(url)
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
        dataset$title, " was updated on ",
        format(time, "%Y-%m-%d")
      ))
    }
    data
  })
  return(output)
}

create_data_dir <- function(dir, ask, dataset) {
  if (ask) {
    ans <- gtools::ask(paste("opendatascot would like to store'",
      dataset$title, "'dataset in the directory: ",
      dir, "Is that okay? Key '1' Go ahead",
      sep = "\n"
    ))
    ans <- as.numeric(ans)
    if (ans != 1) stop("No problem, stopping process", call. = FALSE)
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
