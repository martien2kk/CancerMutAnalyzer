#' Calculate GC Content of Extracted Sequences
#'
#' This function calculates the GC content (the percentage of G and C bases) for each sequence around a mutation site.
#'
#' @param sequences A character vector of DNA sequences, typically obtained from the \code{extractMutationSequences} function.
#' @return A numeric vector with GC content percentages for each sequence in the input.
#'
#' @details
#' This function assumes that the input sequences are in a character vector format, with each element representing a DNA sequence.
#' The GC content is calculated as the percentage of 'G' and 'C' bases in each sequence, relative to the total length of the sequence.
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
#'
#' # Extract sequences
#' extracted_data <- extractMutationSequences(UCS.mutations_snp_first_100, 15)
#' extracted_sequences <- extracted_data$sequences
#'
#' # Calculate GC content for extracted sequences
#' gc_content <- calculateGCContent(extracted_sequences)
#' print(gc_content)
#' }
#'
#' @export
calculateGCContent <- function(sequences) {
  if (!is.character(sequences)) {
    stop("The sequences parameter should be a character vector of DNA sequences.")
  }

  # Calculate GC content for each sequence
  gc_content <- sapply(sequences, function(seq) {
    gc_count <- sum(strsplit(seq, NULL)[[1]] %in% c("G", "C"))
    (gc_count / nchar(seq)) * 100
  })

  return(gc_content)
}
