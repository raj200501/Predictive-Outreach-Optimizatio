# Load necessary libraries
library(dplyr)

# Function to generate personalized outreach plan
generate_outreach_plan <- function(data, engagement_scores) {
  data %>%
    left_join(engagement_scores, by = "customer_id") %>%
    mutate(outreach_plan = case_when(
      engagement_score > 8 ~ 'High Priority',
      engagement_score > 5 ~ 'Medium Priority',
      TRUE ~ 'Low Priority'
    ))
}

# Load data and engagement scores
data <- read.csv('data/features.csv')
engagement_scores <- read.csv('data/engagement_scores.csv')

# Generate outreach plan
outreach_plan <- generate_outreach_plan(data, engagement_scores)

# Save outreach plan
write.csv(outreach_plan, 'data/outreach_plan.csv', row.names = FALSE)
