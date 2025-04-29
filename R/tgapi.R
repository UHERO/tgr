#' Validate and format date inputs
#' @param date Date input (string or Date object)
#' @return Formatted date string
validate_date <- function(date) {
  if (inherits(date, "Date")) {
    return(format(date, "%Y-%m-%d"))
  }

  # For string input, first check if it matches YYYY-MM-DD format
  if (!grepl("^\\d{4}-\\d{2}-\\d{2}$", date)) {
    stop("Date must be in YYYY-MM-DD format (e.g., 2024-01-01)")
  }

  # Try to parse string date
  tryCatch(
    {
      formatted_date <- as.Date(date)
      if (is.na(formatted_date)) {
        stop("Invalid date. Please provide a valid date in YYYY-MM-DD format")
      }
      return(format(formatted_date, "%Y-%m-%d"))
    },
    error = function(e) {
      stop("Invalid date. Please provide a valid date in YYYY-MM-DD format")
    }
  )
}

#' Validate price parameters
#' @param min_price Minimum price
#' @param max_price Maximum price
#' @return List of validated prices
validate_prices <- function(min_price, max_price) {
  # Convert to numeric if provided as strings
  if (!is.null(min_price)) {
    min_price <- as.numeric(min_price)
    if (is.na(min_price)) stop("Invalid minimum price")
  }

  if (!is.null(max_price)) {
    max_price <- as.numeric(max_price)
    if (is.na(max_price)) stop("Invalid maximum price")
  }

  # Check price range validity
  if (!is.null(min_price) && !is.null(max_price)) {
    if (min_price >= max_price) {
      stop("Minimum price must be less than maximum price")
    }
  }

  list(min_price = min_price, max_price = max_price)
}

#' Validate selected fields against schema
#' @param fields Vector of field names
#' @return Validated field names
validate_fields <- function(fields) {
  valid_fields <- c(
    "id", "taxKey", "recDate", "docType", "firstPartyName", "secondPartyName",
    "conveyanceAmount", "considerationAmount", "condoName", "taxClass",
    "transactionType", "neighborhood", "region", "ownerName", "lessee",
    "mailingAddress", "mailingApartmentNo", "mailingCity", "mailingState",
    "mailingZipCode", "mailingCountry", "totalMarketValue", "buildingMarketValue",
    "landMarketValue", "buildingValue", "landValue", "totalAssessedValue",
    "buildingExemption", "landExemption", "totalExemption", "netValue",
    "totalNetValue", "assessmentValues", "propertyAddress", "zoning",
    "propertyArea", "mortgageType", "maturityDate",
    "currentTotalMarketValue",
    "currentBuildingMarketValue",
    "currentLandMarketValue",
    "currentBuildingValue",
    "currentLandValue",
    "currentTotalAssessedValue",
    "currentBuildingExemption",
    "currentLandExemption",
    "currentTotalExemption",
    "currentNetValue",
    "currentTotalNetValue"
  )

  invalid_fields <- setdiff(fields, valid_fields)
  if (length(invalid_fields) > 0) {
    stop(sprintf("Invalid fields specified: %s", paste(invalid_fields, collapse = ", ")))
  }

  fields
}

#' Make API request with retry logic
#' @param url API endpoint
#' @param headers Request headers
#' @param attempts Maximum number of retry attempts
#' @return JSON response
make_request <- function(url, headers, attempts = 2) {
  for (i in 1:attempts) {
    tryCatch(
      {
        response <- request(url) |>
          req_headers(!!!headers) |>
          req_user_agent("UHERO TG API R Package (https://uhero.hawaii.edu)") |>
          req_perform()

        return(resp_body_json(response))
      },
      error = function(e) {
        if (i == attempts) {
          stop(sprintf("Request failed after %d attempts: %s", attempts, e$message))
        }
        Sys.sleep(2^i) # Exponential backoff
      }
    )
  }
}

#' Process JSON response into tibble
#' @param json JSON response
#' @param selected_fields Fields to include in output
#' @param tmk Tax map key
#' @param min_price Minimum sales price
#' @param max_price Maximum sales price
#' @return Tibble with selected fields
process_response <- function(json, selected_fields = NULL, tmk = NULL, min_price = NULL, max_price = NULL) {
  if (length(json) == 0) {
    return(tibble())
  }

  # Create mapping functions based on data types
  field_types <- list(
    id = \(x) map_int(x, "id", .default = NA),
    taxKey = \(x) map_chr(x, "taxKey", .default = NA),
    recDate = \(x) map_chr(x, "recDate", .default = NA),
    docType = \(x) map_chr(x, "docType", .default = NA),
    firstPartyName = \(x) map_chr(x, "firstPartyName", .default = NA),
    secondPartyName = \(x) map_chr(x, "secondPartyName", .default = NA),
    conveyanceAmount = \(x) map_dbl(x, "conveyanceAmount", .default = NA),
    considerationAmount = \(x) map_dbl(x, "considerationAmount", .default = NA),
    condoName = \(x) map_chr(x, "condoName", .default = NA),
    taxClass = \(x) map_chr(x, "taxClass", .default = NA),
    transactionType = \(x) map_chr(x, "transactionType", .default = NA),
    neighborhood = \(x) map_chr(x, "neighborhood", .default = NA),
    region = \(x) map_chr(x, "region", .default = NA),
    ownerName = \(x) map_chr(x, "ownerName", .default = NA),
    lessee = \(x) map_chr(x, "lessee", .default = NA),
    mailingAddress = \(x) map_chr(x, "mailingAddress", .default = NA),
    mailingApartmentNo = \(x) map_chr(x, "mailingApartmentNo", .default = NA),
    mailingCity = \(x) map_chr(x, "mailingCity", .default = NA),
    mailingState = \(x) map_chr(x, "mailingState", .default = NA),
    mailingZipCode = \(x) map_chr(x, "mailingZipCode", .default = NA),
    mailingCountry = \(x) map_chr(x, "mailingCountry", .default = NA),
    totalMarketValue = \(x) map_dbl(x, "totalMarketValue", .default = NA),
    buildingMarketValue = \(x) map_dbl(x, "buildingMarketValue", .default = NA),
    landMarketValue = \(x) map_dbl(x, "landMarketValue", .default = NA),
    buildingValue = \(x) map_dbl(x, "buildingValue", .default = NA),
    landValue = \(x) map_dbl(x, "landValue", .default = NA),
    totalAssessedValue = \(x) map_dbl(x, "totalAssessedValue", .default = NA),
    buildingExemption = \(x) map_dbl(x, "buildingExemption", .default = NA),
    landExemption = \(x) map_dbl(x, "landExemption", .default = NA),
    totalExemption = \(x) map_dbl(x, "totalExemption", .default = NA),
    netValue = \(x) map_dbl(x, "netValue", .default = NA),
    totalNetValue = \(x) map_dbl(x, "totalNetValue", .default = NA),
    assessmentValues = \(x) map_chr(x, "assessmentValues", .default = NA),
    propertyAddress = \(x) map_chr(x, "propertyAddress", .default = NA),
    zoning = \(x) map_chr(x, "zoning", .default = NA),
    propertyArea = \(x) map_chr(x, "propertyArea", .default = NA),
    mortgageType = \(x) map_chr(x, "mortgageType", .default = NA),
    maturityDate = \(x) map_chr(x, "maturityDate", .default = NA),
    currentTotalMarketValue = \(x) map_chr(x, "currentTotalMarketValue", default = NA),
    currentBuildingMarketValue = \(x) map_chr(x, "currentBuildingMarketValue", default = NA),
    currentLandMarketValue = \(x) map_chr(x, "currentLandMarketValue", default = NA),
    currentBuildingValue = \(x) map_chr(x, "currentBuildingValue", default = NA),
    currentLandValue = \(x) map_chr(x, "currentLandValue", default = NA),
    currentTotalAssessedValue = \(x) map_chr(x, "currentTotalAssessedValue", default = NA),
    currentBuildingExemption = \(x) map_chr(x, "currentBuildingExemption", default = NA),
    currentLandExemption = \(x) map_chr(x, "currentLandExemption", default = NA),
    currentTotalExemption = \(x) map_chr(x, "currentTotalExemption", default = NA),
    currentNetValue = \(x) map_chr(x, "currentNetValue", default = NA),
    currentTotalNetValue = \(x) map_chr(x, "currentTotalNetValue", default = NA)
  )

  all_fields <- names(field_types)

  # Select fields to process
  if (is.null(selected_fields)) {
    selected_fields <- all_fields
  }

  # Create a list of processed columns
  processed_data <- list()
  for (field in all_fields) {
    processed_data[[field]] <- field_types[[field]](json)
  }

  # Create tibble from processed data
  tibble_data <- as_tibble(processed_data)

  if (!is.null(tmk)) {
    tibble_data <- filter(tibble_data, tibble_data$taxKey == tmk)
  }
  if (!is.null(min_price)) {
    tibble_data <- filter(tibble_data, tibble_data$conveyanceAmount >= min_price)
  }
  if (!is.null(max_price)) {
    tibble_data <- filter(tibble_data, tibble_data$conveyanceAmount <= max_price)
  }
  if (!is.null(selected_fields)) {
    tibble_data <- tibble_data %>% select(all_of(selected_fields))
  }
  tibble_data
}

#' GET data from TG API with enhanced features
#'
#' @param startDate Start date (Date object or string in YYYY-MM-DD format)
#' @param endDate End date (Date object or string in YYYY-MM-DD format)
#' @param tmk Optional TMK parameter
#' @param min_price Optional minimum sales price
#' @param max_price Optional maximum sales price
#' @param fields Optional vector of field names to include
#' @return Tibble containing API response data
#' @export
tg <- function(startDate, endDate, tmk = NULL, min_price = NULL, max_price = NULL, fields = NULL) {
  # Validate inputs
  startDate <- validate_date(startDate)
  endDate <- validate_date(endDate)

  if (!is.null(fields)) {
    fields <- validate_fields(fields)
  }

  prices <- validate_prices(min_price, max_price)

  # Set up API credentials
  api_user <- Sys.getenv("TG_User")
  api_key <- Sys.getenv("TG_Key")

  if (api_user == "" || api_key == "") {
    stop("API credentials not found. Please set TG_User and TG_Key environment variables.")
  }

  headers <- list(
    `X-Api-User` = api_user,
    `X-Api-Key` = api_key,
    accept = "application/json"
  )

  # Generate date sequence for weekly batches
  dates <- seq(as.Date(startDate), as.Date(endDate), by = "7 days")
  if (as.Date(endDate) > utils::tail(dates, 1)) {
    dates <- c(dates, as.Date(endDate))
  }

  # Process batches
  results <- list()

  for (i in 1:(length(dates) - 1)) {
    batch_start <- format(dates[i], "%Y-%m-%d")
    batch_end <- format(dates[i + 1], "%Y-%m-%d")

    url <- sprintf(
      "https://dataservices.tghawaii.com/api/UHero/GetData/%s/%s",
      batch_start, batch_end
    )

    req <- httr2::request(url)

    tryCatch(
      {
        batch_data <- make_request(url, headers)
        results[[i]] <- process_response(
          batch_data, fields, tmk,
          prices$min_price, prices$max_price
        )
      },
      error = function(e) {
        # If batch fails, try with smaller window
        warning(sprintf(
          "Weekly batch failed, attempting 3-day windows for %s to %s",
          batch_start, batch_end
        ))

        smaller_dates <- seq(as.Date(batch_start), as.Date(batch_end), by = "3 days")
        if (as.Date(batch_end) > utils::tail(smaller_dates, 1)) {
          smaller_dates <- c(smaller_dates, as.Date(batch_end))
        }

        for (j in 1:(length(smaller_dates) - 1)) {
          small_start <- format(smaller_dates[j], "%Y-%m-%d")
          small_end <- format(smaller_dates[j + 1], "%Y-%m-%d")

          url <- sprintf(
            "https://dataservices.tghawaii.com/api/UHero/GetData/%s/%s",
            small_start, small_end
          )

          req <- httr2::request(url)

          batch_data <- make_request(req, headers)
          results[[length(results) + 1]] <- process_response(
            batch_data, fields,
            tmk, prices$min_price,
            prices$max_price
          )
        }
      }
    )
  }

  dplyr::bind_rows(results)
}
