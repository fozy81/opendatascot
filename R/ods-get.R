#' Get Data From Open Data Scotland
#'
#' Return data from https://opendata.scot/ website. Currently, only datasets in
#' CSV, JSON and GeoJSON formats supported. If data is not available in these
#' formats, a warning is provided. By default data is saved locally to avoid
#' re-downloading on subsequent requests.
#'
#' @param data Dataframe from `ods_search()` or if default (NULL), will download
#'   all datasets.
#' @param search Search term(s) if `data` parameter not provided.
#' @param refresh Refresh cached data. If data has changed remotely, use this to
#'   update or renew corrupted data/cache. This will download data again and
#'   update the cache.
#' @param ask If FALSE, user will not be prompted for input to download data.
#'   This is useful to automate data downloads and cache updated, or speed-up
#'   the process if downloading many datasets at once.
#'
#' @importFrom rlang .data
#' @importFrom tibble as_tibble
#' @importFrom readr read_csv read_file
#' @importFrom dplyr filter select
#' @importFrom tidyr unnest
#' @importFrom gtools ask
#' @importFrom rappdirs user_data_dir
#' @importFrom sf st_read
#' @importFrom jsonlite fromJSON
#' @importFrom utils read.csv download.file unzip
#' @return list of named data frames. GeoJSON data is converted to simple
#'   features `sf` class to aid spatial analysis.
#' @export
#'
#' @examples
#' search <- ods_search("bins")
#' data <- ods_get(search, refresh = TRUE, ask = FALSE)
ods_get <- function(data = NULL,
                    search = NULL,
                    refresh = FALSE,
                    ask = TRUE) {
  data <- validate_data(data, search)
  output <- lapply(split(data, data$unique_id), function(dataset) {
    dir <- opendatascot_dir()
    file_name <- dataset$unique_id
    file_name <- paste0(file_name, ".rds")
    file_path <- file.path(dir, file_name)
    if (!file.exists(file_path) || refresh) {
      title <- dataset$title
      dataset <- select(dataset, .data$title, .data$resources)
      dataset <- unnest(dataset, cols = "resources", names_sep = "_")
      dataset <- filter(dataset, .data$resources_format %in%
        c("CSV", "GEOJSON", "JSON", "ZIP"))
      if (nrow(dataset) < 1) {
        warning(
          paste(title,
            "Is not available in a supported format (CSV, GEOJSON, KML & JSON),
          try direct download from openscot.data",
            sep = "\n"
          ),
          call. = FALSE
        )
        return()
      }
      create_data_dir(dir, ask, dataset[1, ])
      if (any(dataset$resources_format %in% "GEOJSON")) {
        dataset <- filter(dataset, .data$resources_format %in%
          c("GEOJSON", "KML"))
        url <- dataset$resources_url[1]
        data <- read_file(url)
        data <- st_read(dsn = data, quiet = TRUE)
      } else if (any(dataset$resources_format %in% "CSV")) {
        dataset <- filter(dataset, .data$resources_format == "CSV")
        url <- dataset$resources_url[1]
        data <- read_csv(url, show_col_types = FALSE)
        data <- as_tibble(data)
      } else if (any(dataset$resources_format %in% "JSON")) {
        dataset <- filter(dataset, .data$resources_format == "JSON")
        url <- dataset$resources_url[1]
        # Workaround for url not returning all results - 'limit(-1)' returns all
        url <- gsub(pattern = "[0-9]/urql", "latest/urql?limit(-1)", url)
        data <- read_file(url)
        data <- fromJSON(txt = data, flatten = TRUE)
        data <- as_tibble(data)
      } else {
        dataset <- filter(dataset, .data$resources_format == "ZIP")
        if (nrow(dataset) < 1) {
          warning(
            paste(title,
              "Is not available in a supported format (CSV, GEOJSON & JSON),
          try direct download from openscot.data",
              sep = "\n"
            ),
            call. = FALSE
          )
          return()
        }
        url <- dataset$resources_url[1]
        # create temp file to download zip into
        temp <- tempfile(fileext = ".zip")
        utils::download.file(url, temp)
        wd <- getwd()
        temp_dir <- tempdir()
        lapply(temp, utils::unzip, exdir = temp_dir)
        csv_files <- list.files(
          path = temp_dir,
          pattern = "*.csv",
          recursive = TRUE
        )
        if (length(csv_files) < 1) {
          warning(
            paste(title,
              "Is not available in a supported format (CSV, GEOJSON & JSON),
          try direct download from openscot.data",
              sep = "\n"
            ),
            call. = FALSE
          )
          return()
        }
        setwd(temp_dir)
        data <- lapply(csv_files, function(x) {
          data <- utils::read.csv(
            file = x,
            check.names = FALSE,
            header = FALSE,
            stringsAsFactors = FALSE,
            fileEncoding = "latin1"
          )
        })
        unlink(temp)
        unlink(temp_dir)
        setwd(wd)
        data <- dplyr::bind_rows(data)
        data <- as_tibble(data)
      }
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
    ans <- ask(paste("opendatascotland would like to store: ",
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
    default = user_data_dir("opendatascot")
  )
}

validate_data <- function(data, search) {
  if (is.null(data) && is.null(search)) {
    message(
      "`data` & `search` arguments are NULL, downloading all ods datasets!"
    )
    data <- ods_search()
  }

  if (!is.null(data) && !is.null(search)) {
    stop(
      "You provided values to both data and search parameters, only one can be
      used"
    )
  }

  if (!is.null(search)) {
    data <- ods_search(search)
    if (nrow(data) < 1) {
      return(data)
    }
  }
  stopifnot("data must be a dataframe" = any(class(data) %in% "data.frame"))
  stopifnot("data must have more than one row" = nrow(data) != 0)
  stopifnot("data must have `unique_id` column" = !is.null(data$unique_id))
  return(data)
}
