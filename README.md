
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uherotgr

<!-- badges: start -->
<!-- badges: end -->

The goal of uherotgr is to …

## Installation

You can install the development version of uherotgr from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("UHERO/tgr")
```

This package requires the following environment variables to be set

    TG_User
    TG_Key

Edit your `~/.Renviron` or create one using `usethis::edit_r_environ()`.
TG_User should equal the username and TG_Key should equal the API Key
needed to access Title Guarantee’s API.

## How to use

`tg()` accepts 2 string parameters: a start date and an end date of the
form YYYY-MM-DD The date range cannot exceed 90 days.
`data <- tg('2024-01-01', '2024-01-03')`
