# Utility helpers shared across scripts.

require_columns <- function(data, required_columns) {
  missing_columns <- setdiff(required_columns, colnames(data))
  if (length(missing_columns) > 0) {
    stop(
      sprintf(
        "Missing required columns: %s",
        paste(missing_columns, collapse = ", ")
      )
    )
  }
  invisible(TRUE)
}

safe_divide <- function(numerator, denominator, default = 0) {
  ifelse(is.na(denominator) | denominator == 0, default, numerator / denominator)
}

ensure_directory <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE)
  }
  invisible(path)
}

standardize_region <- function(region) {
  region <- trimws(region)
  region <- tolower(region)
  region <- ifelse(region %in% c("north", "south", "east", "west"), region, "unknown")
  tools::toTitleCase(region)
}

derive_outreach_success <- function(total_purchases, total_interactions, avg_time_spent) {
  score <- (total_purchases / 500) + (total_interactions / 20) + (avg_time_spent / 5)
  ifelse(score >= 3, "yes", "no")
}
