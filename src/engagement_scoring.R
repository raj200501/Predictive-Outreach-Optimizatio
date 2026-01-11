# Load necessary libraries
library(dplyr)

source("src/utils.R")

# Function to score customer engagement
score_engagement <- function(data) {
  require_columns(data, c("total_interactions", "total_page_views", "total_purchases", "avg_purchase_value"))
  data %>%
    mutate(
      engagement_score = total_interactions +
        total_page_views +
        safe_divide(total_purchases, avg_purchase_value, default = 0)
    )
}

run_engagement_scoring <- function(
  features_path = "data/features.csv",
  output_path = "data/engagement_scores.csv"
) {
  data <- read.csv(features_path)

  engagement_scores <- score_engagement(data)

  write.csv(engagement_scores, output_path, row.names = FALSE)
  engagement_scores
}

if (sys.nframe() == 0) {
  run_engagement_scoring()
}
