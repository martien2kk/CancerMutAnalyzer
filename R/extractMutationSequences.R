#' Extract Sequences Around Mutation Sites
#'
#' This function extracts nucleotide sequences surrounding mutation sites from the hg19 genome
#' based on provided genomic coordinates. By default, it extracts a trinucleotide sequence centered
#' around each mutation (one base on each side), but the padding size can be adjusted.
#'
#' @param data A data frame containing mutation data, which must include the columns \code{"Chromosome"}
#'             and \code{"Start_position"}.
#' @param padding An integer specifying the number of bases to include on each side of the mutation
#'                position. Default is \code{1}, which extracts a trinucleotide sequence.
#' @param return.DNAStringSet A logical value. If \code{TRUE}, returns the sequences as a \code{DNAStringSet}
#'                            object; if \code{FALSE}, returns the sequences as a character vector in a new
#'                            column added to the input \code{data} data frame. Default is \code{FALSE}.
#'
#' @return A modified version of the input \code{data} with an additional column \code{sequences} containing
#'         the extracted nucleotide sequences as character strings, or a \code{DNAStringSet} if
#'         \code{return.DNAStringSet = TRUE}.
#'
#' @details
#' The function requires the \code{BSgenome.Hsapiens.UCSC.hg19} package, which provides access to the
#' hg19 reference genome. Chromosome names are automatically converted to UCSC format (prefixed with "chr")
#' if not already in this format. The function extracts sequences using the specified \code{padding} value,
#' centered on the mutation \code{Start_position}.
#'
#' @examples
#' \dontrun{
#' # Load necessary libraries
#' library(BSgenome.Hsapiens.UCSC.hg19)
#' library(GenomicRanges)
#'
#'
#' sampleDataset <- data.frame(
#'   Chromosome = c("1", "2", "3"),
#'   Start_position = c(123456, 234567, 345678)
#' )
#'
#' # Example 1
#' # Extract trinucleotide sequences around each mutation site
#' trinucleotide_data <- extractMutationSequences(sampleDataset)
#' print(trinucleotide_data)
#'
#' # Example 2
#' # Extract sequences with larger padding and return as DNAStringSet
#' sequences_dnastringset <- extractMutationSequences(sampleDataset, padding = 10, return.DNAStringSet = TRUE)
#' print(sequences_dnastringset)
#'
#' # Example 3
#' extractMutationSequences(UCS.mutations_snp_first_100)
#' }
#'
#' @import GenomicRanges
#' @import BSgenome.Hsapiens.UCSC.hg19
#'
#'@export
filterMutations <- function(data, conditions) {
  # Check if conditions are provided
  if (is.null(conditions) || length(conditions) == 0) {
    stop("Please provide a list of conditions to filter by.")
  }

  # Apply each condition sequentially
  for (col in names(conditions)) {
    if (!col %in% names(data)) {
      stop(paste("Column", col, "not found in the data."))
    }

    # Get condition for the column
    condition <- conditions[[col]]

    # Ensure the column is numeric if we are applying a range filter
    if (is.vector(condition) && length(condition) == 2) {
      data[[col]] <- as.numeric(data[[col]])
    }

    # Apply the condition based on its type
    if (is.vector(condition) && length(condition) == 1) {
      # Exact match
      data <- data[data[[col]] == condition, ]
    } else if (is.vector(condition) && length(condition) == 2) {
      # Range filtering for numeric columns
      if (is.numeric(data[[col]])) {
        data <- data[data[[col]] >= condition[1] & data[[col]] <= condition[2], ]
      } else {
        stop(paste("Range filtering is only applicable to numeric columns. Column", col, "is not numeric."))
      }
    } else {
      stop("Invalid condition format. Use a single value or a two-element numeric vector for range filtering.")
    }
  }

  return(data)
}
