# Load necessary libraries
library(dplyr)
library(tidyr)

# Function to preprocess customer demographics data
preprocess_demographics <- function(data) {
  data %>%
    mutate(age_group = case_when(
      age < 18 ~ 'Under 18',
      age >= 18 & age < 35 ~ '18-34',
      age >= 35 & age < 50 ~ '35-49',
      age >= 50 & age < 65 ~ '50-64',
      age >= 65 ~ '65+'
    )) %>%
    select(-age)
}

# Function to preprocess purchase history data
preprocess_purchase_history <- function(data) {
  data %>%
    group_by(customer_id) %>%
    summarise(total_purchases = sum(purchase_amount),
              avg_purchase_value = mean(purchase_amount))
}

# Function to preprocess social media interactions data
preprocess_social_media <- function(data) {
  data %>%
    group_by(customer_id) %>%
    summarise(total_interactions = sum(interactions),
              avg_interactions_per_day = mean(interactions))
}

# Function to preprocess behavioral data
preprocess_behavioral_data <- function(data) {
  data %>%
    group_by(customer_id) %>%
    summarise(total_page_views = sum(page_views),
              avg_time_spent = mean(time_spent))
}

# Load and preprocess data
demographics <- read.csv('data/customer_demographics.csv')
purchase_history <- read.csv('data/purchase_history.csv')
social_media <- read.csv('data/social_media_interactions.csv')
behavioral_data <- read.csv('data/behavioral_data.csv')

demographics <- preprocess_demographics(demographics)
purchase_history <- preprocess_purchase_history(purchase_history)
social_media <- preprocess_social_media(social_media)
behavioral_data <- preprocess_behavioral_data(behavioral_data)

# Save preprocessed data
write.csv(demographics, 'data/preprocessed_demographics.csv', row.names = FALSE)
write.csv(purchase_history, 'data/preprocessed_purchase_history.csv', row.names = FALSE)
write.csv(social_media, 'data/preprocessed_social_media.csv', row.names = FALSE)
write.csv(behavioral_data, 'data/preprocessed_behavioral_data.csv', row.names = FALSE)
