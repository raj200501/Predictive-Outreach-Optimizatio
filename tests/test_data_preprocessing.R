library(testthat)

source("src/data_preprocessing.R")

test_that("Data preprocessing works correctly", {
  demographics <- read.csv('data/customer_demographics.csv')
  processed_demographics <- preprocess_demographics(demographics)
  expect_equal(ncol(processed_demographics), 4)
  expect_true("age_group" %in% colnames(processed_demographics))
})

test_that("Purchase history preprocessing works correctly", {
  purchase_history <- read.csv('data/purchase_history.csv')
  processed_purchase_history <- preprocess_purchase_history(purchase_history)
  expect_equal(ncol(processed_purchase_history), 3)
  expect_true("total_purchases" %in% colnames(processed_purchase_history))
})
