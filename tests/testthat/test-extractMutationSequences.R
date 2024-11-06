library(CancerMutAnalyzer)

test_that("sequence extraction with padding", {

  # Sample input data
  sample_data <- data.frame(
    Chromosome = c("1", "2", "3"),
    Start_position = c(123456, 234567, 345678)
  )

  # Test extraction with default padding (trinucleotide sequence)
  extracted_data <- extractMutationSequences(sample_data)

  # Test that output is a data frame
  expect_type(extracted_data, "list")

  # Test that output includes a 'sequences' column with correct length
  expect_true("sequences" %in% names(extracted_data))
  expect_equal(length(extracted_data$sequences), nrow(sample_data))

  # Test that extracted sequences have the expected length (e.g: trinucleotide with padding = 1)
  expect_true(all(nchar(extracted_data$sequences) == 3))
})
