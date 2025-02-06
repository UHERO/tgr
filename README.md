
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uherotgr

<!-- badges: start -->
<!-- badges: end -->

This package interfaces with the API provided by Title Guaranty. It returns a list of transaction records. Contact wood2@hawaii.edu for the API Key and Username. The API is only accessible from UH or the UH VPN.

### TG Resources
Docs: https://dataservices.tghawaii.com/swagger/index.html
api url: https://dataservices.tghawaii.com/api/UHero/GetData/

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
