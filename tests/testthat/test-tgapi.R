# This is a simple test suite and demo of the api.
# Run with:
## source("tgapi.R")
## source("test.R")

# First, set up your API credentials
# Sys.setenv(TG_User = "")
# Sys.setenv(TG_Key = "")



# Install required packages
if (!require("httr2")) install.packages("httr2")
if (!require("dplyr")) install.packages("dplyr")
if (!require("purrr")) install.packages("purrr")


all_fields <- c("id", "taxKey", "recDate", "docType", "firstPartyName",
                "secondPartyName", "conveyanceAmount", "considerationAmount",
                "condoName", "taxClass", "transactionType", "neighborhood",
                "region", "ownerName", "lessee", "mailingAddress", "mailingApartmentNo",
                "mailingCity", "mailingState", "mailingZipCode", "mailingCountry",
                "totalMarketValue", "buildingMarketValue", "landMarketValue", "buildingValue",
                "landValue", "totalAssessedValue", "buildingExemption", "landExemption",
                "totalExemption", "netValue", "totalNetValue", "assessmentValues",
                "propertyAddress", "zoning", "propertyArea", "mortgageType", "maturityDate")
# Test 1: Basic date range query
result1 <- tg(
  startDate = "2024-01-10",
  endDate = "2024-01-14"
)
expect_named(result1, all_fields, ignore.order = TRUE)
print(sprintf("Test 1: Found %d transactions in basic query", nrow(result1)))

# Test 2: Using Date objects instead of strings
result2 <- tg(
  startDate = as.Date("2024-01-10"),
  endDate = as.Date("2024-01-14")
)
expect_named(result2, all_fields, ignore.order = TRUE)
print(sprintf("Test 2: Found %d using Date object", nrow(result2)))

# Test 3: With price range
result3 <- tg(
  startDate = "2024-01-10",
  endDate = "2024-01-14",
  min_price = 100000,
  max_price = 2000000
)
expect_named(result3, all_fields, ignore.order = TRUE)
print(sprintf("Test 3: Found %d transactions within price range", nrow(result3)))

# Test 4: With specific TMK
result4 <- tg(
  startDate = "2024-01-10",
  endDate = "2024-01-14",
  tmk = "1110040760000"
)
expect_named(result4, all_fields, ignore.order = TRUE)
print(sprintf("Test 4: Found %d transactions with given tmk", nrow(result4)))

# Test 5: Select specific fields
selected_fields <- c("id", "taxKey", "recDate", "conveyanceAmount", "condoName")
result5 <- tg(
  startDate = "2024-01-10",
  endDate = "2024-01-14",
  fields = selected_fields
)
expect_named(result5, selected_fields, ignore.order = TRUE)
print(sprintf("Test 5: Returned fields: %s", paste(names(result5), collapse = ", "))) # Should only show selected fields

# Test 6: Combine multiple parameters
result6 <- tg(
  startDate = "2024-01-10",
  endDate = "2024-01-14",
  min_price = 500000,
  max_price = 1000000,
  fields = c("recDate", "conveyanceAmount", "propertyAddress")
)
expect_named(result6, c("recDate", "conveyanceAmount", "propertyAddress"), ignore.order = TRUE)
print(sprintf("Test 6: Found %d transactions with multiple parameters", nrow(result6)))


# Example of error handling
# tryCatch(
#   {
#     # This should fail due to invalid date format
#     result_error <- tg(
#       startDate = "01-01-2024", # Wrong format
#       endDate = "2024-01-14"
#     )
#   },
#   error = function(e) {
#     print(paste("Caught expected error:", e$message))
#   }
# )

# This should fail due to invalid date format
# result_error <- expect_error(
#   tg(
#     startDate = "01-01-2024", # Wrong format
#     endDate = "2024-01-14"
#   )
# )
# Test 7: Expect an error for using the wrong date format
expect_error(
  tg(
    startDate = "01-01-2024", # Wrong format
    endDate = "2024-01-14"
  ),
  "Date must be in YYYY-MM-DD format (e.g., 2024-01-01)",
  fixed = TRUE
)
#expect_equal(result_error, "Date must be in YYYY-MM-DD format (e.g., 2024-01-01)")
