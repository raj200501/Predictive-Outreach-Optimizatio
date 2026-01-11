# Load necessary libraries
library(caret)

source("src/utils.R")

# Function to evaluate model performance
evaluate_model <- function(model, test_data, target_variable) {
  require_columns(test_data, target_variable)
  test_data[[target_variable]] <- as.factor(test_data[[target_variable]])
  predictions <- predict(model, test_data)
  actuals <- test_data[[target_variable]]
  confusion_matrix <- confusionMatrix(predictions, actuals)
  return(confusion_matrix)
}

run_evaluation <- function(
  model_path = "models/outreach_model.rds",
  test_data_path = "data/test_data.csv",
  target_variable = "outreach_success"
) {
  model <- readRDS(model_path)
  test_data <- read.csv(test_data_path)

  evaluation_results <- evaluate_model(model, test_data, target_variable)

  print(evaluation_results)
  evaluation_results
}

if (sys.nframe() == 0) {
  run_evaluation()
}
