api_user <- Sys.getenv("TG_User")
api_key <- Sys.getenv("TG_Key")


tgReq <- function(startDate, endDate) {
  request("https://dataservices.tghawaii.com/api/UHero/GetData") |>
    req_headers_redacted(`X-Api-User` = api_user) |>
    req_headers_redacted(`X-Api-Key` = api_key) |>
    req_user_agent("UHERO TG API R Package (https://uhero.hawaii.edu)") |>
    req_url_path_append(startDate) |>
    req_url_path_append(endDate) |>
    req_perform() |>
    resp_body_json()
}

#' GET data from TG API
#'
#' @param startDate A date string of the format YYYY-MM-DD
#' @param endDate A date string of the format YYYY-MM-DD
#'
#' @returns A tibble of data retrieved from the API
#' @export
#'

tg <- function(startDate, endDate) {
  json <- tgReq(startDate, endDate)

  tibble(
    id = map_int(json, "id"),
    taxKey = map_chr(json, "taxKey", .default = NA),
    recDate = map_chr(json, "recDate", .default = NA),
    docType = map_chr(json, "docType", .default = NA),
    firstPartyName = map_chr(json, "firstPartyName", .default = NA),
    secondPartyName = map_chr(json, "secondPartyName", .default = NA),
    conveyanceAmount = map_dbl(json, "conveyanceAmount", .default = NA),
    considerationAmount = map_dbl(json, "considerationAmount", .default = NA),
    condoName = map_chr(json, "condoName", .default = NA),
    taxClass = map_chr(json, "taxClass", .default = NA),
    transactionType = map_chr(json, "transactionType", .default = NA),
    neighborhood = map_chr(json, "neighborhood", .default = NA),
    region = map_chr(json, "region", .default = NA),
    ownerName = map_chr(json, "ownerName", .default = NA),
    lessee = map_chr(json, "lessee", .default = NA),
    mailingAddress = map_chr(json, "mailingAddress", .default = NA),
    mailingApartmentNo = map_chr(json, "mailingApartmentNo", .default = NA),
    mailingCity = map_chr(json, "mailingCity", .default = NA),
    mailingState = map_chr(json, "mailingState", .default = NA),
    mailingZipCode = map_chr(json, "mailingZipCode", .default = NA),
    mailingCountry = map_chr(json, "mailingCountry", .default = NA),
    totalMarketValue = map_dbl(json, "totalMarketValue", .default = NA),
    buildingMarketValue = map_dbl(json, "buildingMarketValue", .default = NA),
    landMarketValue = map_dbl(json, "landMarketValue", .default = NA),
    buildingValue = map_dbl(json, "buildingValue", .default = NA),
    landValue = map_dbl(json, "landValue", .default = NA),
    totalAssessedValue = map_dbl(json, "totalAssessedValue", .default = NA),
    buildingExemption = map_dbl(json, "buildingExemption", .default = NA),
    landExemption = map_dbl(json, "landExemption", .default = NA),
    totalExemption = map_dbl(json, "totalExemption", .default = NA),
    netValue = map_dbl(json, "netValue", .default = NA),
    totalNetValue = map_dbl(json, "totalNetValue", .default = NA),
    assessmentValues = map_chr(json, "assessmentValues", .default = NA),
    propertyAddress = map_chr(json, "propertyAddress", .default = NA),
    zoning = map_chr(json, "zoning", .default = NA),
    propertyArea = map_chr(json, "propertyArea", .default = NA),
    mortgageType = map_chr(json, "mortgageType", .default = NA),
    maturityDate = map_chr(json, "maturityDate", .default = NA)
  )
}
