context("Test processMutationData")
library(CancerMutAnalyzer)

test_that("Extract specific columns from mutation data", {

  # Sample mutation data to use in tests
  mutation_data <- data.frame(
    Chromosome = c("1", "2", "3"),
    Start_position = c(123456, 234567, 345678),
    End_position = c(123500, 234600, 345700),
    Variant_Type = c("SNP", "DEL", "INS"),
    Reference_Allele = c("A", "G", "T"),
    Tumor_Seq_Allele1 = c("T", "C", "A"),
    Genome_Change = c("g.chr1:123456A>T", "g.chr2:234567G>C", "g.chr3:345678T>A"),
    Tumor_Sample_Barcode = c("TCGA-01", "TCGA-02", "TCGA-03")
  )

  # Test extracting default columns
  extracted_data <- extractMutationData(mutation_data)
  testthat::expect_s3_class(extracted_data, "data.frame")
  testthat::expect_equal(ncol(extracted_data), 8)
  testthat::expect_named(extracted_data, c("Chromosome", "Start_position", "End_position",
                                 "Variant_Type", "Reference_Allele", "Tumor_Seq_Allele1",
                                 "Genome_Change", "Tumor_Sample_Barcode"))


  # Test when selected column does not exist in data frame
  testthat::expect_error(
    extractMutationData(mutation_data, selected_columns = c("Nonexistent_Column")),
    "One or more specified columns do not exist in the data frame."
  )

  # Test when input data is not a data frame
  expect_error(
    extractMutationData(list(Chromosome = c("1", "2"))),
    "Input data must be a data frame."
  )

  # Test that extracted data maintains row count
  expect_equal(nrow(extracted_data), nrow(mutation_data))

})

test_that("filterMutations filters data correctly with specified conditions", {

  # Create a sample dataset
  sample_data <- data.frame(
    Chromosome = c("1", "1", "2", "3"),
    Variant_Type = c("SNP", "DEL", "SNP", "INS"),
    Hugo_Symbol = c("TP53", "BRCA1", "EGFR", "PTEN"),
    Start_position = c(1000, 2000, 1500, 3000)
  )

  # Test filter by exact match on Chromosome and Variant_Type
  filtered_data <- filterMutations(sample_data, conditions = list(Chromosome = "1", Variant_Type = "SNP"))

  testthat::expect_type(filtered_data, "list")
  testthat::expect_s3_class(filtered_data, "data.frame")
  testthat::expect_equal(nrow(filtered_data), 1)
  testthat::expect_equal(filtered_data$Chromosome, "1")
  testthat::expect_equal(filtered_data$Variant_Type, "SNP")


  # Test invalid column name should trigger an error
  testthat::expect_error(
    filterMutations(sample_data, conditions = list(InvalidColumn = "test")),
    "Column InvalidColumn not found in the data."
  )

  # Test range filtering on a non-numeric column should trigger an error
  testthat::expect_error(
    filterMutations(sample_data, conditions = list(Chromosome = c(1, 3))),
    "Range filtering is only applicable to numeric columns."
  )
})

# [END]
