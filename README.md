
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

```R
pak::pak("UHERO/tgr")
library(uherotgr)

result <- tg(
  startDate = as.Date("2024-01-10"),
  endDate = as.Date("2024-01-14")
)
```

## Data Dictionary
| **API Field**        | **Requested Data**                                         | **Data Description** |
|----------------------|-----------------------------------------------------------|----------------------|
| ID                   | Internal identifier for tracking purposes.                 | Can be used to help identify a particular listing if you have a question on the data. Otherwise, it can be ignored. |
| recDate              | Rec Date                                                  | Bureau recorded date |
| docType              | DocType                                                   | Type of instrument |
| firstPartyName       | First Party Name                                          | Owner (seller) / mortgagor name from PI search |
| secondPartyName      | Second Party Name / Grantee Name                          | Buyer name / Lender name from PI search |
| conveyanceAmount     | Consideration/Amount or Deed Address Sales Amount        | Recorded conveyance amount |
| considerationAmount  | Conveyance Tax Amount / Mortgage Amount                   | Recorded mortgage amount |
| condoName            | Condominium Name                                          | Name of the condo building if available/applicable |
| taxKey               | Tax Key                                                   | TMK from county tax data |
| taxclass             | Tax Class                                                 | Tax class from county tax data |
| transactionType      | Type of Transaction                                       | Case Sale or Sales with Mortgage or Mortgage (Refinance or Consumer Loan) |
| neighborhood         | Neighborhood                                             | Location of properties based on the zone section of the tax key |
| region               | Region                                                   | Section/portion of the island i.e. Central, Leeward, Windward |
| ownerName            | Owner Name                                               | Property owner from county tax data |
| lessee               | Lessee / Vendee                                          | Lessee from county tax data |
| mailingAddress       | Mailing Address (Tax Bill address for owner / lessee)   | Mailing address for tax purposes |
| mailingAppartmentNo  | Apartment No.                                          | Mailing address for tax purposes |
| mailingCity          | City                                                    | Mailing address for tax purposes |
| mailingState         | State                                                   | Mailing address for tax purposes |
| mailingZipCode       | Zip Code                                                | Mailing address for tax purposes |
| mailingCountry       | Country                                                 | Mailing address for tax purposes |
| totalMarketValue     | Total Market Value                                      | Total market value from county tax assessments |
| buildingMarketValue  | Building Market Value                                  | Building market value from county tax assessments |
| landMarketValue      | Land Market Value                                       | Land market value from county tax assessments |
| buildingValue        | Building Value                                         | Building value from county tax assessments |
| landValue            | Land Value                                              | Land value from county tax assessments |
| totalAssessedValue   | Total Assessed Value                                  | Total assessed value from county tax assessments |
| buildingExemption    | Building Exemption                                     | Building exemption from county tax assessments |
| landExemption        | Land Exemption                                          | Land exemption from county tax assessments |
| totalExemption       | Total Exemption                                         | Total exemption from county tax assessments |
| netValue             | Net Value                                               | Net value from county tax assessments |
| totalNetValue        | Total Net Value                                         | Total net value from county tax assessments |
| propertyAddress      | Property Address                                       | Property location address from county records |
| assessmentValues     | Assessment Values for Current Tax Year                  | Assessment from county tax data for the current tax year |
| zoning               | Zoning                                                  | Zoning from county tax assessments (this will mainly be null as we have some data but the info is not complete). |
| propertyArea         | Property Area                                          | Property area from county tax data (Acres or Sq Ft) |
| mortgageType         | Mortgage Type                                          | Loan type - conventional, VA, FHA, CL (HELOC / credit line) |
| maturityDate         | Maturity Date                                          | Due date for the loan |
