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

# Test 1: Basic date range query
result1 <- tg(
    startDate = "2024-01-10",
    endDate = "2024-01-14"
)
print(sprintf("Test 1: Found %d transactions in basic query", nrow(result1)))

# Test 2: Using Date objects instead of strings
result2 <- tg(
    startDate = as.Date("2024-01-10"),
    endDate = as.Date("2024-01-14")
)
print(sprintf("Test 2: Found %d using Date object", nrow(result2)))

# Test 3: With price range
result3 <- tg(
    startDate = "2024-01-10",
    endDate = "2024-01-14",
    min_price = 100000,
    max_price = 2000000
)
print(sprintf("Test 3: Found %d transactions within price range", nrow(result3)))

# Test 4: With specific TMK
result4 <- tg(
    startDate = "2024-01-10",
    endDate = "2024-01-14",
    tmk = "1110300590000"
)
print(sprintf("Test 4: Found %d transactions with given tmk", nrow(result4)))

# Test 5: Select specific fields
selected_fields <- c("id", "taxKey", "recDate", "conveyanceAmount", "condoName")
result5 <- tg(
    startDate = "2024-01-10",
    endDate = "2024-01-14",
    fields = selected_fields
)
print(sprintf("Test 5: Returned fields: %s", paste(names(result5), collapse = ", "))) # Should only show selected fields

# Test 6: Combine multiple parameters
result6 <- tg(
    startDate = "2024-01-10",
    endDate = "2024-01-14",
    min_price = 500000,
    max_price = 1000000,
    fields = c("recDate", "conveyanceAmount", "propertyAddress")
)
print(sprintf("Test 6: Found %d transactions with multiple parameters", nrow(result6)))

# Example of error handling
tryCatch(
    {
        # This should fail due to invalid date format
        result_error <- tg(
            startDate = "01-01-2024", # Wrong format
            endDate = "2024-01-14"
        )
    },
    error = function(e) {
        print(paste("Caught expected error:", e$message))
    }
)

# Check the structure of the returned data
# str(result1)
quit(save = "no")
