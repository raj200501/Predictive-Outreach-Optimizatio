# Load necessary libraries
library(dplyr)

# Function to score customer engagement
score_engagement <- function(data) {
  data %>%
    mutate(engagement_score = total_interactions + total_page_views + total_purchases / avg_purchase_value)
}

# Load data
data <- read.csv('data/features.csv')

# Score engagement
engagement_scores <- score_engagement(data)

# Save engagement scores
write.csv(engagement_scores, 'data/engagement_scores.csv', row.names = FALSE)
