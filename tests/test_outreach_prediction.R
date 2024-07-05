library(testthat)

source("src/outreach_prediction.R")

test_that("Outreach prediction works correctly", {
  model <- readRDS('models/outreach_model.rds')
  new_data <- read.csv('data/new_data.csv')

  predictions <- predict_outreach(model, new_data)
  expect_equal(length(predictions), nrow(new_data))
})
