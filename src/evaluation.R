# Load necessary libraries
library(caret)

# Function to evaluate model performance
evaluate_model <- function(model, test_data, target_variable) {
  predictions <- predict(model, test_data)
  actuals <- test_data[[target_variable]]
  confusion_matrix <- confusionMatrix(predictions, actuals)
  return(confusion_matrix)
}

# Load model and test data
model <- readRDS('models/outreach_model.rds')
test_data <- read.csv('data/test_data.csv')
target_variable <- 'outreach_success'

# Evaluate model
evaluation_results <- evaluate_model(model, test_data, target_variable)

# Print evaluation results
print(evaluation_results)
