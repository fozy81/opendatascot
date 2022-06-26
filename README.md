
<!-- README.md is generated from README.Rmd. Please edit that file -->

# opendatascot

<!-- badges: start -->
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
data <- get_data(search = 'Number of bikes')
#> Number of bikes available for private use - Travel and Transport Scotland 2016 - Scottish Household Survey was updated on 2022-06-25
#> Number of bikes available for private use - Travel and Transport Scotland 2017 - Scottish Household Survey was updated on 2022-06-25
#> Number of bikes available for private use - Travel and Transport Scotland 2018 - Scottish Household Survey was updated on 2022-06-25
#> Number of bikes available for private use - Travel and Transport Scotland 2019 - Scottish Household Survey was updated on 2022-06-25
```
