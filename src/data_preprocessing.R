# Load necessary libraries
library(dplyr)
library(tidyr)

source("src/utils.R")

# Function to preprocess customer demographics data
preprocess_demographics <- function(data) {
  require_columns(data, c("customer_id", "age", "gender", "region"))

  data %>%
    mutate(
      age_group = case_when(
        age < 18 ~ "Under 18",
        age >= 18 & age < 35 ~ "18-34",
        age >= 35 & age < 50 ~ "35-49",
        age >= 50 & age < 65 ~ "50-64",
        age >= 65 ~ "65+"
      ),
      region = standardize_region(region)
    ) %>%
    select(customer_id, gender, region, age_group)
}

# Function to preprocess purchase history data
preprocess_purchase_history <- function(data) {
  require_columns(data, c("customer_id", "purchase_amount"))

  data %>%
    group_by(customer_id) %>%
    summarise(
      total_purchases = sum(purchase_amount, na.rm = TRUE),
      avg_purchase_value = mean(purchase_amount, na.rm = TRUE),
      .groups = "drop"
    )
}

# Function to preprocess social media interactions data
preprocess_social_media <- function(data) {
  require_columns(data, c("customer_id", "interactions"))

  data %>%
    group_by(customer_id) %>%
    summarise(
      total_interactions = sum(interactions, na.rm = TRUE),
      avg_interactions_per_day = mean(interactions, na.rm = TRUE),
      .groups = "drop"
    )
}

# Function to preprocess behavioral data
preprocess_behavioral_data <- function(data) {
  require_columns(data, c("customer_id", "page_views", "time_spent"))

  data %>%
    group_by(customer_id) %>%
    summarise(
      total_page_views = sum(page_views, na.rm = TRUE),
      avg_time_spent = mean(time_spent, na.rm = TRUE),
      .groups = "drop"
    )
}

run_preprocessing <- function(
  demographics_path = "data/customer_demographics.csv",
  purchase_history_path = "data/purchase_history.csv",
  social_media_path = "data/social_media_interactions.csv",
  behavioral_path = "data/behavioral_data.csv",
  output_dir = "data"
) {
  ensure_directory(output_dir)

  demographics <- read.csv(demographics_path)
  purchase_history <- read.csv(purchase_history_path)
  social_media <- read.csv(social_media_path)
  behavioral_data <- read.csv(behavioral_path)

  demographics <- preprocess_demographics(demographics)
  purchase_history <- preprocess_purchase_history(purchase_history)
  social_media <- preprocess_social_media(social_media)
  behavioral_data <- preprocess_behavioral_data(behavioral_data)

  write.csv(demographics, file.path(output_dir, "preprocessed_demographics.csv"), row.names = FALSE)
  write.csv(purchase_history, file.path(output_dir, "preprocessed_purchase_history.csv"), row.names = FALSE)
  write.csv(social_media, file.path(output_dir, "preprocessed_social_media.csv"), row.names = FALSE)
  write.csv(behavioral_data, file.path(output_dir, "preprocessed_behavioral_data.csv"), row.names = FALSE)

  list(
    demographics = demographics,
    purchase_history = purchase_history,
    social_media = social_media,
    behavioral_data = behavioral_data
  )
}

if (sys.nframe() == 0) {
  run_preprocessing()
}
