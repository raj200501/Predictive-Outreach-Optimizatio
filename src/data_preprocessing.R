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

# Load and preprocess data
demographics <- read.csv('data/customer_demographics.csv')
purchase_history <- read.csv('data/purchase_history.csv')

demographics <- preprocess_demographics(demographics)
purchase_history <- preprocess_purchase_history(purchase_history)

# Save preprocessed data
write.csv(demographics, 'data/preprocessed_demographics.csv', row.names = FALSE)
write.csv(purchase_history, 'data/preprocessed_purchase_history.csv', row.names = FALSE)
