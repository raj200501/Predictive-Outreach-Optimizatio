# Load necessary libraries
library(dplyr)
library(tidyr)

source("src/utils.R")

# Function to create features from preprocessed data
create_features <- function(demographics, purchase_history, social_media, behavioral_data) {
  require_columns(demographics, c("customer_id", "gender", "region", "age_group"))
  require_columns(purchase_history, c("customer_id", "total_purchases", "avg_purchase_value"))
  require_columns(social_media, c("customer_id", "total_interactions", "avg_interactions_per_day"))
  require_columns(behavioral_data, c("customer_id", "total_page_views", "avg_time_spent"))

  demographics %>%
    left_join(purchase_history, by = "customer_id") %>%
    left_join(social_media, by = "customer_id") %>%
    left_join(behavioral_data, by = "customer_id") %>%
    mutate(
      purchase_per_interaction = safe_divide(total_purchases, total_interactions, default = 0),
      time_per_page_view = safe_divide(avg_time_spent, total_page_views, default = 0),
      outreach_success = derive_outreach_success(total_purchases, total_interactions, avg_time_spent)
    )
}

run_feature_engineering <- function(
  demographics_path = "data/preprocessed_demographics.csv",
  purchase_history_path = "data/preprocessed_purchase_history.csv",
  social_media_path = "data/preprocessed_social_media.csv",
  behavioral_path = "data/preprocessed_behavioral_data.csv",
  output_path = "data/features.csv"
) {
  demographics <- read.csv(demographics_path)
  purchase_history <- read.csv(purchase_history_path)
  social_media <- read.csv(social_media_path)
  behavioral_data <- read.csv(behavioral_path)

  features <- create_features(demographics, purchase_history, social_media, behavioral_data)

  write.csv(features, output_path, row.names = FALSE)
  features
}

if (sys.nframe() == 0) {
  run_feature_engineering()
}
