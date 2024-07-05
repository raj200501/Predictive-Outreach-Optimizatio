# Load necessary libraries
library(caret)

# Function to predict outreach success
predict_outreach <- function(model, new_data) {
  predictions <- predict(model, new_data)
  return(predictions)
}

# Load model and new data
model <- readRDS('models/outreach_model.rds')
new_data <- read.csv('data/new_data.csv')

# Predict outreach success
predictions <- predict_outreach(model, new_data)

# Save predictions
write.csv(predictions, 'data/predictions.csv', row.names = FALSE)
