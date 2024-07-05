library(testthat)

source("src/model_training.R")

test_that("Model training works correctly", {
  features <- read.csv('data/features.csv')
  train_data <- features[complete.cases(features), ]
  target_variable <- 'outreach_success'

  model <- train_model(train_data, target_variable)
  expect_true(inherits(model, "randomForest"))
})
