
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatascotland

<img src='https://github.com/fozy81/opendatascot/blob/master/inst/sticker/scotmaps.png?raw=true' align="right" width="300" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

`opendatascotland` is an R package to download and locally cache data
from [opendata.scot](https://opendata.scot/).

## Installation

You can install the development version of opendatascot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fozy81/opendatascot")
```

## Example

#### Search or view all datasets available on [opendata.scot](https://opendata.scot/)

``` r
library(opendatascotland)
# View all available datasets and associated metadata
all_datasets <- search_ods()

# Search dataset titles containing matching terms (case insensitive)
single_query <- search_ods("Number of bikes")

# Search multiple terms
multi_query <- search_ods(c("Bins", "Number of bikes"))
```

#### Download datasets

``` r
query <- search_ods("Number of bikes")
data <- get_ods(query)
#> 'Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
```

Or use the search parameter in get_ods to search

``` r
data <- get_ods(search = "Number of bikes")
#> 'Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
#> 'Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey' dataset was last downloaded on 2022-07-24
```

By default you be ask if you want to save the data locally on the first
download. Optionally, you can refresh the data or avoid being asked to
save data.

``` r
data <- get_ods(search = "Number of bikes", refresh = TRUE, ask = FALSE)
```

#### Plot datasets

``` r
data <- get_ods(search = "Air Quality - Diffusion Tubes")
```

The get_ods() function returned a named list of data frames - lets
select the one we want by name:

``` r
air_tubes <- data$`Air_Quality_-_Diffusion_Tubes_Aberdeen_City_Council`
```

Or alternatively select the first data frame in the list using index of
1.

``` r
air_tubes <- data[[1]]
```

We can see the data frame is also classed as “sf” which has spatial /
geometry attributes baked in.

``` r
class(air_tubes) 
#> [1] "sf"         "data.frame"
```

This means plot function will automatically plot the coordinates.

``` r
plot(air_tubes$geometry)
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />
