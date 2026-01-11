# Load necessary libraries
library(caret)

source("src/utils.R")

# Function to predict outreach success
predict_outreach <- function(model, new_data) {
  predictions <- predict(model, new_data)
  return(predictions)
}

run_outreach_prediction <- function(
  model_path = "models/outreach_model.rds",
  new_data_path = "data/new_data.csv",
  output_path = "data/predictions.csv"
) {
  model <- readRDS(model_path)
  new_data <- read.csv(new_data_path)

  predictions <- predict_outreach(model, new_data)

  write.csv(predictions, output_path, row.names = FALSE)
  predictions
}

if (sys.nframe() == 0) {
  run_outreach_prediction()
}
