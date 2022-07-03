
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatascot

<!-- badges: start -->

[![R-CMD-check](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/fozy81/opendatascot/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

`opendatascot` is a R package to download and locally cache data from
<https://opendata.scot/> .

## Installation

You can install the development version of opendatascot from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("fozy81/opendatascot")
```

## Example

Search and download dataets from opendata.scot

``` r
library(opendatascot)
## basic example code
search <- search_ods('Number of bikes')
data <- get_ods(search)
#> 'Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey' dataset was last downloaded on 2022-07-03
#> 'Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey' dataset was last downloaded on 2022-07-03
#> 'Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey' dataset was last downloaded on 2022-07-03
#> 'Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey' dataset was last downloaded on 2022-07-03
```
