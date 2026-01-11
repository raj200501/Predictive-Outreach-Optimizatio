# Load necessary libraries
library(caret)
library(randomForest)

source("src/utils.R")

# Function to train predictive model
train_model <- function(train_data, target_variable) {
  require_columns(train_data, target_variable)
  train_data[[target_variable]] <- as.factor(train_data[[target_variable]])
  set.seed(123)
  model <- randomForest(as.formula(paste(target_variable, "~ .")), data = train_data, ntree = 100)
  return(model)
}

run_model_training <- function(
  features_path = "data/features.csv",
  output_path = "models/outreach_model.rds",
  target_variable = "outreach_success"
) {
  ensure_directory(dirname(output_path))
  features <- read.csv(features_path)
  train_data <- features[complete.cases(features), ]

  model <- train_model(train_data, target_variable)

  saveRDS(model, output_path)
  model
}

if (sys.nframe() == 0) {
  run_model_training()
}
