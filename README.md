
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

Search or view all datasets available on
[opendata.scot](https://opendata.scot/)

``` r
library(opendatascotland)
# View all available datasets and associated metadata
all_datasets <- search_ods()

# Search dataset titles containing matching terms (case insensitive)
single_query <- search_ods("Number of bikes")

# Search multiple terms
multi_query <- search_ods(c("Bins", "Number of bikes"))
```

Download datasets

``` r
query <- search_ods("Number of bikes")
data <- get_ods(query)
#> 'Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
# or
data <- get_ods(search = "Number of bikes")
#> 'Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
#> 'Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey' dataset was last downloaded on 2022-07-23
```
