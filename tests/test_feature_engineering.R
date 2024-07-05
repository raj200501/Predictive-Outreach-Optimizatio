library(testthat)

source("src/feature_engineering.R")

test_that("Feature engineering works correctly", {
  demographics <- read.csv('data/preprocessed_demographics.csv')
  purchase_history <- read.csv('data/preprocessed_purchase_history.csv')
  social_media <- read.csv('data/preprocessed_social_media.csv')
  behavioral_data <- read.csv('data/preprocessed_behavioral_data.csv')

  features <- create_features(demographics, purchase_history, social_media, behavioral_data)
  expect_equal(ncol(features), 10)
  expect_true("purchase_per_interaction" %in% colnames(features))
})
