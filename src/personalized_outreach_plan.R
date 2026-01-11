# Load necessary libraries
library(dplyr)

source("src/utils.R")

# Function to generate personalized outreach plan
generate_outreach_plan <- function(data, engagement_scores) {
  require_columns(data, "customer_id")
  require_columns(engagement_scores, c("customer_id", "engagement_score"))
  data %>%
    left_join(engagement_scores, by = "customer_id") %>%
    mutate(outreach_plan = case_when(
      engagement_score > 8 ~ 'High Priority',
      engagement_score > 5 ~ 'Medium Priority',
      TRUE ~ 'Low Priority'
    ))
}

run_outreach_plan <- function(
  features_path = "data/features.csv",
  engagement_scores_path = "data/engagement_scores.csv",
  output_path = "data/outreach_plan.csv"
) {
  data <- read.csv(features_path)
  engagement_scores <- read.csv(engagement_scores_path)

  outreach_plan <- generate_outreach_plan(data, engagement_scores)

  write.csv(outreach_plan, output_path, row.names = FALSE)
  outreach_plan
}

if (sys.nframe() == 0) {
  run_outreach_plan()
}
