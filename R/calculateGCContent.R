#' Calculate GC Content of Extracted Sequences
#'
#' This function calculates the GC content (the percentage of G and C bases) for each sequence around a mutation site
#' with help of the Biostrings package.
#'
#' @param sequences A character vector of DNA sequences, typically obtained from the \code{extractMutationSequences} function.
#' @return A numeric vector with GC content percentages for each sequence in the input.
#'
#' @details
#' This function assumes that the input sequences are in a character vector format, with each element representing a DNA sequence.
#' The GC content is calculated as the percentage of 'G' and 'C' bases in each sequence, relative to the total length of the sequence.
#' The function relies on the Biostrings package for efficient sequence handling and GC content calculation.
#'
#' @examples
#' \dontrun{
#' # Example 1
#' # Calculate GC content for a predefined set of sequences
#' sequences <- c("ATGCGT", "CGCGGC", "ATATAT")
#' gc_content <- calculateGCContent(sequences)
#' print(gc_content)
#'
#' # Example 2
#' # Extract sequences around mutation sites and calculate their GC content
#' library(BSgenome.Hsapiens.UCSC.hg19)
#' library(GenomicRanges)
#'
#' # Extract sequences
#' extracted_data <- extractMutationSequences(filteredUCSFirst100SNP, 15)
#' extracted_sequences <- extracted_data$sequences
#'
#' # Calculate GC content for extracted sequences
#' gc_content <- calculateGCContent(extracted_sequences)
#' print(gc_content)
#' }
#'
#' @import Biostrings
#'
#' @references
#' Pagès H, Aboyoun P, Gentleman R, DebRoy S (2024). _Biostrings: Efficient manipulation of biological
#' strings_. doi:10.18129/B9.bioc.Biostrings <https://doi.org/10.18129/B9.bioc.Biostrings>, R package version
#' 2.72.1, <https://bioconductor.org/packages/Biostrings>.
#'
#' @export
calculateGCContent <- function(sequences) {
  if (!is.character(sequences)) {
    stop("The sequences parameter should be a character vector of DNA sequences.")
  }

  # Convert character vector to DNAStringSet using Biostrings
  dna_sequences <- Biostrings::DNAStringSet(sequences)

  # Calculate GC content as a single percentage per sequence using Biostrings::letterFrequency
  gc_content <- rowSums(Biostrings::letterFrequency(dna_sequences, letters = c("G", "C"), as.prob = TRUE)) * 100

  # Create a data frame with sequences and their GC content
  result <- data.frame(sequence = sequences, gc_content = gc_content)

  return(result)
}
