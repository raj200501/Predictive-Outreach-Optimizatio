# Load necessary libraries
library(dplyr)
library(tidyr)

# Function to create features from social media interactions data
create_social_media_features <- function(data) {
  data %>%
    group_by(customer_id) %>%
    summarise(total_interactions = n(),
              avg_interactions_per_day = mean(interactions_per_day))
}

# Load and create features from data
social_media_data <- read.csv('data/social_media_interactions.csv')
social_media_features <- create_social_media_features(social_media_data)

# Save features
write.csv(social_media_features, 'data/social_media_features.csv', row.names = FALSE)
