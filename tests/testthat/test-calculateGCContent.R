context("Test calculateGCContent")
library(CancerMutAnalyzer)

test_that("calculateGCContent calculates correct GC content for given sequences", {

  sequences <- c("ATGCGT", "CGCGGC", "ATATAT")
  result <- calculateGCContent(sequences)

  # Expected GC content calculations
  expected_gc_content <- c(50, 100, 0)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("sequence", "gc_content") %in% colnames(result)))
  expect_equal(result$gc_content, expected_gc_content)
})

test_that("calculateGCContent handles edge cases", {

  empty_sequences <- character(0)
  result_empty <- calculateGCContent(empty_sequences)

  # Test that function handles an empty data frame as output
  expect_s3_class(result_empty, "data.frame")
  expect_equal(nrow(result_empty), 0)

  # Test that function handles sequences with no /all GC content
  sequences_no_gc <- c("AAAA", "TTTT", "AAAAA")
  result_no_gc <- calculateGCContent(sequences_no_gc)

  sequences_all_gc <- c("GGGG", "CCCC", "GGGGG")
  result_all_gc <- calculateGCContent(sequences_all_gc)

  expect_equal(result_no_gc$gc_content, c(0, 0, 0))
  expect_equal(result_all_gc$gc_content, c(100, 100, 100))

  # Test that non-character input should throw an error
  expect_error(calculateGCContent(123), "The sequences parameter should be a character vector of DNA sequences.")
})
