# Load necessary libraries
library(dplyr)
library(tidyr)

# Function to create features from preprocessed data
create_features <- function(demographics, purchase_history, social_media, behavioral_data) {
  demographics %>%
    left_join(purchase_history, by = "customer_id") %>%
    left_join(social_media, by = "customer_id") %>%
    left_join(behavioral_data, by = "customer_id") %>%
    mutate(purchase_per_interaction = total_purchases / total_interactions,
           time_per_page_view = avg_time_spent / total_page_views)
}

# Load preprocessed data
demographics <- read.csv('data/preprocessed_demographics.csv')
purchase_history <- read.csv('data/preprocessed_purchase_history.csv')
social_media <- read.csv('data/preprocessed_social_media.csv')
behavioral_data <- read.csv('data/preprocessed_behavioral_data.csv')

# Create features
features <- create_features(demographics, purchase_history, social_media, behavioral_data)

# Save features
write.csv(features, 'data/features.csv', row.names = FALSE)
