library(testthat)

source("src/engagement_scoring.R")

test_that("Engagement scoring works correctly", {
  data <- read.csv('data/features.csv')
  engagement_scores <- score_engagement(data)
  expect_true("engagement_score" %in% colnames(engagement_scores))
  expect_equal(nrow(engagement_scores), nrow(data))
})
