
<!-- README.md is generated from README.Rmd. Please edit that file -->

# uherotgr

<!-- badges: start -->
<!-- badges: end -->

This package interfaces with the API provided by Title Guaranty. It returns a list of transaction records. Contact wood2@hawaii.edu for the API Key and Username. The API is only accessible from the UH network or the UH VPN. You may also use the API directly with any http tool or library of your choice, this package handles a few basics conveniently for you:
- batches the requests. The api itself has only a few fields to filter on, and will fail to respond if the requested time frame contains too many records. To handle this the tgr package allows you to specify any time frame, and will make requests to the api in small batches, reducing the load on their server and combining the responses into a single tibble. 
- Adds some additional filter options. The package allows you to select specific fields to include in your response. 
- Validates your field name inputs to ensure you're requesting fields that exist.

If you hit any bugs or see any room for improvement please open a github issue or slack Caleb and Vicky.

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

This will return a Tibble containing records meeting the specified criteria.

```R
pak::pak("UHERO/tgr")
library(uherotgr)

result <- tg(
  startDate = as.Date("2024-01-10"),
  endDate = as.Date("2024-01-14")
)
```

## Data Dictionary

### The following fields show the value of a deed transfer at time of its recordation, if available.
- TotalMarketValue
- BuildingMarketValue
- LandMarketValue
- BuildingValue
- LandValue
- TotalAssessedValue
- BuildingExemption
- LandExemption
- TotalExemption
- NetValue
- TotalNetValue

### These fields show the current assessed value of a deed transfer.  
- CurrentTotalMarketValue
- CurrentBuildingMarketValue
- CurrentLandMarketValue
- CurrentBuildingValue
- CurrentLandValue
- CurrentTotalAssessedValue
- CurrentBuildingExemption
- CurrentLandExemption
- CurrentTotalExemption
- CurrentNetValue
- CurrentTotalNetValue


| **API Field**        | **Requested Data**                                         | **Data Description** |
|----------------------|-----------------------------------------------------------|----------------------|
| ID                   | Internal identifier for tracking purposes.                | Can be used to help identify a particular listing if you have a question on the data. Otherwise, it can be ignored. |
| recDate              | Rec Date                                                  | Bureau recorded date |
| docType              | DocType                                                   | Type of instrument |
| assessmentValues     | Assessment Values for Current Tax Year                  | Assessment from county tax data for the current tax year |
| buildingExemption    | Building Exemption                                     | Building exemption from county tax assessments |
| buildingMarketValue  | Building Market Value                                  | Building market value from county tax assessments |
| buildingValue        | Building Value                                         | Building value from county tax assessments |
| conveyanceAmount     | Consideration/Amount or Deed Address Sales Amount        | Recorded conveyance amount |
| considerationAmount  | Conveyance Tax Amount / Mortgage Amount                   | Recorded mortgage amount, if pesent |
| condoName            | Condominium Name                                          | Name of the condo building if available/applicable |
| currentTotalMarketValue     |  Current Total Market Value                        |         |
| currentBuildingMarketValue  |   Current Building Market Value                    |    xyz     |
| currentLandMarketValue      |   Current Land Market Value                        |    xyz     |
| currentBuildingValue        |   Current Building Value                           |    Assessed Bldg. Value from RPT records     |
| currentLandValue            |   Current Land Value                               |    Assessed Land Value from RPT records     |
| currentTotalAssessedValue   |   Current Total Assessed Value                     |    Total Property Assessed Value from RPT Records     |
| currentBuildingExemption    |   Current Building Exemption                       |    Building Exemption from RPT records     |
| currentLandExemption        |   Current Land Exemption                           |    Land Exemption from RPT records     |
| currentTotalExemption       |   Current Total Exemption                          |    Total Property Exemption from RPT records     |
| currentNetValue             |   Current Net Value                                |    Total Property Assessed Value     |
| currentTotalNetValue        |   Current Total Net Value                          |    Total Net Taxable Value from RPT records     |
| firstPartyName       | First Party Name                                          | Owner (seller) / mortgagor name from PI search |
| landExemption        | Land Exemption                                          | Land exemption from county tax assessments |
| landMarketValue      | Land Market Value                                       | Land market value from county tax assessments |
| landValue            | Land Value                                              | Land value from county tax assessments |
| lessee               | Lessee / Vendee                                          | Lessee from county tax data |
| mailingAddress       | Mailing Address (Tax Bill address for owner / lessee)   | Mailing address for tax purposes |
| mailingAppartmentNo  | Apartment No.                                          | Mailing address for tax purposes |
| mailingCity          | City                                                    | Mailing address for tax purposes |
| mailingState         | State                                                   | Mailing address for tax purposes |
| mailingZipCode       | Zip Code                                                | Mailing address for tax purposes |
| mailingCountry       | Country                                                 | Mailing address for tax purposes |
| maturityDate         | Maturity Date                                          | Due date for the loan |
| mortgageType         | Mortgage Type                                          | Loan type - conventional, VA, FHA, CL (HELOC / credit line) |
| neighborhood         | Neighborhood                                             | Location of properties based on the zone section of the tax key |
| netValue             | Net Value                                               | Net value from county tax assessments |
| ownerName            | Owner Name                                               | Property owner from county tax data |
| propertyAddress      | Property Address                                       | Property location address from county records |
| propertyArea         | Property Area                                          | Property area from county tax data. ex: Acres "0.00AC" or Sq Ft "2410SF" |
| region               | Region                                                   | Section/portion of the island i.e. Central, Leeward, Windward |
| secondPartyName      | Second Party Name / Grantee Name                          | Buyer name / Lender name from PI search |
| taxclass             | Tax Class                                                 | Tax class from county tax data |
| taxKey               | Tax Key                                                   | TMK from county tax data |
| totalMarketValue     | Total Market Value                                      | Total market value from county tax assessments |
| transactionType      | Type of Transaction                                       | Case Sale or Sales with Mortgage or Mortgage (Refinance or Consumer Loan) |
| totalAssessedValue   | Total Assessed Value                                  | Total assessed value from county tax assessments |
| totalExemption       | Total Exemption                                         | Total exemption from county tax assessments |
| totalMarketValue     | Total Market Value                                    |        |
| totalNetValue        | Total Net Value                                         | Total net value from county tax assessments |
| zoning               | Zoning                                                  | Zoning from county tax assessments (this will mainly be null as we have some data but the info is not complete). |
