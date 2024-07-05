# Load necessary libraries
library(caret)
library(randomForest)

# Function to train predictive model
train_model <- function(train_data, target_variable) {
  set.seed(123)
  model <- randomForest(as.formula(paste(target_variable, "~ .")), data = train_data, ntree = 100)
  return(model)
}

# Load and prepare training data
features <- read.csv('data/features.csv')
train_data <- features[complete.cases(features), ]
target_variable <- 'outreach_success'

# Train model
model <- train_model(train_data, target_variable)

# Save model
saveRDS(model, 'models/outreach_model.rds')
