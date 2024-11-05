context("Test visualizeMutationFrequency")
library(CancerMutAnalyzer)

test_that("visualizeMutationFrequencyBar creates a bar plot", {

  sample_data <- data.frame(
    Chromosome = c("1", "1", "2", "2", "3"),
    SNP_Mutation = c("A", "T", "A", "G", "C")
  )


  plot <- visualizeMutationFrequencyBar(sample_data, group_by_column = "Chromosome")

  # Test that output is a ggplot object
  expect_s3_class(plot, "ggplot")

  # Test that an error is thrown for an invalid column
  expect_error(visualizeMutationFrequencyBar(sample_data, group_by_column = "NonexistentColumn"),
               "The specified grouping column does not exist in the data.")
})


test_that("visualizeMutationFrequencyHeatmap creates a heatmap", {

  sample_data <- data.frame(
    Reference_Allele = c("A", "T", "A", "G", "C"),
    Tumor_Seq_Allele2 = c("G", "C", "T", "A", "G")
  )


  plot <- visualizeMutationFrequencyHeatmap(sample_data, group_by_columns = c("Reference_Allele", "Tumor_Seq_Allele2"))

  # Test that the output is a ggplot object
  expect_s3_class(plot, "ggplot")

  # Test that an error is thrown for an invalid column
  expect_error(visualizeMutationFrequencyHeatmap(sample_data, group_by_columns = c("InvalidColumn", "Tumor_Seq_Allele2")),
               "One or more specified columns do not exist in the data.")

  #Test that an error is thrown for incorrect number of columns
  expect_error(visualizeMutationFrequencyHeatmap(sample_data, group_by_columns = "Reference_Allele"),
               "Please specify exactly two column names for the heatmap.")
})
