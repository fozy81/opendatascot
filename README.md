
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatascotland

<img src='https://github.com/fozy81/opendatascot/blob/master/inst/sticker/scotmaps.png?raw=true' align="right" width="300" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Codecov test
coverage](https://codecov.io/gh/fozy81/opendatascot/branch/master/graph/badge.svg)](https://app.codecov.io/gh/fozy81/opendatascot?branch=master)
<!-- badges: end -->

`opendatascotland` is an [R](https://www.r-project.org/) package to
download and locally cache data from the amazing
[opendata.scot](https://opendata.scot/) website. This helps to quickly
start data analysis by providing a simple way to save, organise and
import data in R.

## Installation

You can install the development version of `opendatascotland` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fozy81/opendatascot")
```

## Search

Search all available datasets by using the `ods_search()` function.
Additionally, use the `search` argument to filter datasets by title.

``` r
library(opendatascotland)
# View all available datasets and associated metadata
all_datasets <- ods_search()

# Search dataset titles containing matching terms (case insensitive)
single_query <- ods_search("Number of bikes")

# Search multiple terms
multi_query <- ods_search(c("Bins", "Number of bikes"))
head(multi_query, 4)
#> # A tibble: 4 × 11
#>   unique_id    title organ…¹ notes categ…² url   resou…³ licence date_…⁴ date_…⁵
#>   <chr>        <chr> <chr>   <chr> <list>  <chr> <list>  <chr>   <chr>   <chr>  
#> 1 Salt_Bins_D… Salt… Dumfri… "<p>… <chr>   /dat… <df>    UK Ope… 2017-1… 2019-0…
#> 2 Public_Litt… Publ… Dundee… "<p>… <chr>   /dat… <df>    UK Ope… 2018-0… 2019-0…
#> 3 Solar_Power… Sola… Dundee… "<p>… <chr>   /dat… <df>    Open D… 2018-0… 2019-0…
#> 4 Number_of_b… Numb… Cyclin… "<p>… <chr>   /dat… <df>    UK Ope… 2018-0… 2023-0…
#> # … with 1 more variable: org_type <chr>, and abbreviated variable names
#> #   ¹​organization, ²​category, ³​resources, ⁴​date_created, ⁵​date_updated
```

Note, search term is case-insensitive but word order must be correct
(there is no ‘fuzzy’ matching).

## Download

Currently, only datasets available in `.csv`, `.json` or `.geojson` can
be downloaded. These formats cover the majority of data available. You
will be warned if data can’t be downloaded.

To download data, you can either download the metadata using
`ods_search()`, then pass that data frame to `ods_get()`

``` r
query <- ods_search("bins")
data <- ods_get(query)
#> 'Public Litter Bins' dataset was last downloaded on 2023-04-30
#> 'Salt Bins' dataset was last downloaded on 2023-04-30
#> 'Solar Powered Compactor Bins' dataset was last downloaded on 2023-04-30
```

Or use the search argument in `ods_get(search="my search term")` to
search and download matching datasets in one step.

``` r
data <- ods_get(search = "bins")
#> 'Public Litter Bins' dataset was last downloaded on 2023-04-30
#> 'Salt Bins' dataset was last downloaded on 2023-04-30
#> 'Solar Powered Compactor Bins' dataset was last downloaded on 2023-04-30
```

By default, you will be asked if you want to save the data locally on
the first download. Optionally, you can refresh the data or avoid being
asked to save data.

``` r
data <- ods_get(search = "Number of bikes", refresh = TRUE, ask = FALSE)
```

## Plot

``` r
data <- ods_get(search = "Recycling Point Locations")
```

The `ods_get()` function returned a named list of data frames - lets
select the one we want by name:

``` r
recycling_points <- data$Recycling_Point_Locations_Dundee_City_Council
```

Or alternatively select the first data frame in the list using index of
1.

``` r
recycling_points <- data[[1]]
```

Geojson datasets are automating converted to [simple
feature](https://r-spatial.github.io/sf/) ‘sf’ data. As we can see in
the example the data frame is classed as “sf” which mean spatial /
geometry coordinates are held in a `geometry` column.

``` r
class(recycling_points) 
#> [1] "sf"         "data.frame"
```

These allows the `plot()` function to automatically plot the coordinates
in the geometry column.

``` r
plot(recycling_points$geometry, 
     col = as.factor(recycling_points$LOCATION))
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />
