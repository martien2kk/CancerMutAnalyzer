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
#' sequences_dnastringset <- extractMutationSequences(filteredUCSFirst100SNP, padding = 10, return.DNAStringSet = TRUE)
#' print(sequences_dnastringset)
#'
#' # Example 3
#' extractMutationSequences(filteredUCSFirst100SNP)
#' }
#'
#' @import GenomicRanges
#' @import BSgenome.Hsapiens.UCSC.hg19
#' @import S4Vectors
#'
#' @references
#' Lawrence, M., Huber, W., Pagès, H., Aboyoun, P., Carlson, M., et al. (2013).
#' _Software for Computing and Annotating Genomic Ranges_. PLoS Computational Biology, 9(8), e1003118.
#' https://doi.org/10.1371/journal.pcbi.1003118
#'
#' Pagès H, Lawrence M, Aboyoun P (2024). _S4Vectors: Foundation of vector-like and list-like containers in
#' Bioconductor_. doi:10.18129/B9.bioc.S4Vectors <https://doi.org/10.18129/B9.bioc.S4Vectors>, R package
#' version 0.42.1, <https://bioconductor.org/packages/S4Vectors>.
#'
#' Team TBD (2020). _BSgenome.Hsapiens.UCSC.hg19: Full genome sequences for Homo sapiens (UCSC version hg19,
#' based on GRCh37.p13)_. R package version 1.4.3.
#'
#' @export
extractMutationSequences <- function(data, padding = 1, return.DNAStringSet = FALSE) {
  # Validate input data
  if (!("Chromosome" %in% names(data) && "Start_position" %in% names(data))) {
    stop("Data must include 'Chromosome' and 'Start_position' columns.")
  }

  # Ensure Start_position is numeric
  data$Start_position <- as.numeric(data$Start_position)

  # Ensure chromosome names are in the correct UCSC format
  data$Chromosome <- ifelse(
    grepl("^chr", data$Chromosome),
    data$Chromosome,
    paste0("chr", data$Chromosome)
  )

  # Create a GRanges object from the input mutation data
  mutations_gr <- GenomicRanges::GRanges(
    seqnames = factor(data$Chromosome),
    ranges = IRanges::IRanges(start = data$Start_position - padding, end = data$Start_position + padding)
  )

  # Get hg19 reference sequence for the GRanges object
  mutation_sequences <- BSgenome::getSeq(BSgenome.Hsapiens.UCSC.hg19::Hsapiens, mutations_gr)

  if (return.DNAStringSet) {
    # Return as DNAStringSet if requested
    return(mutation_sequences)
  } else {
    # Convert DNAStringSet to a character vector
    mutation_sequences <- as.character(mutation_sequences)
    # Add this vector as a new column to the input data
    data$sequences <- mutation_sequences
    return(data)
  }
}
