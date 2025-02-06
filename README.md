
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

`tg()` accepts the following paramters:  
- `startDate`: **required** Date object or string in YYYY-MM-DD format  
- `endDate`: **required** Date object or string in YYYY-MM-DD format  
- `tmk`: *optional* Tax map key  
- `min_price`: *optional* Minimum sales price  
- `max_price`: *optional* Maximum sales price  
- `fields`: *optional* Vector of field names to include
