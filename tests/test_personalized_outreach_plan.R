library(testthat)

source("src/personalized_outreach_plan.R")

test_that("Personalized outreach plan works correctly", {
  data <- read.csv('data/features.csv')
  engagement_scores <- read.csv('data/engagement_scores.csv')

  outreach_plan <- generate_outreach_plan(data, engagement_scores)
  expect_true("outreach_plan" %in% colnames(outreach_plan))
  expect_equal(nrow(outreach_plan), nrow(data))
})
