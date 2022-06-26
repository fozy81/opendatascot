opendatascot_env <- new.env(parent = emptyenv())

.onAttach <- function(libname, pkgname) {
  if (interactive()) {
    packageStartupMessage(
      paste0(
        c(
          "IN DEVELOPMENT - Only downloads datasets available in .csv format.",
          "Explore datasets on https://opendata.scot/"
        ),
        sep = "\n"
      ),
      paste0(
        "Datasets are cached to '",
        opendatascot_dir(),
        "' after first download."
      )
    )
  }
}

.onLoad <- function(...) {
  assign("opendatascot_message", FALSE, envir = opendatascot_env)
}
