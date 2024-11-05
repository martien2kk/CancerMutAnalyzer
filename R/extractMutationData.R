#' Extract Specific Columns from Mutation Data
#'
#' This function extracts specified columns from a mutation dataset. It has default settings
#' for commonly used columns but allows for user customization. It checks whether the input
#' is a data frame and whether the specified columns exist in the data frame.
#'
#' @param mutation_data A data frame containing mutation data.
#' @param selected_columns A character vector specifying the columns to be extracted from the
#'        mutation_data data frame. Default columns are:
#'        \itemize{
#'          \item \code{"Chromosome"}: The chromosome number on which the mutation occurs.
#'          \item \code{"Start_position"}: The starting position of the mutation on the chromosome.
#'          \item \code{"End_position"}: The ending position of the mutation on the chromosome.
#'          \item \code{"Variant_Type"}: The type of mutation, such as single nucleotide polymorphisms (SNP), deletion, or insertion.
#'          \item \code{"Reference_Allele"}: The base(s) found on the reference allele at the position of the mutation.
#'          \item \code{"Tumor_Seq_Allele1"}: The base(s) found in the tumor sample at the mutation position.
#'          \item \code{"Tumor_Sample_Barcode"}: A unique identifier for the tumor sample in which the mutation was detected.
#'        }
#'
#' @return Returns a data frame containing only the columns specified by the user.
#'
#' @examples
#' # Example 1
#'
#' \dontrun{
#' library(RTCGA.mutations)
#' data(UCS.mutations)
#' extractMutationData(UCS.mutations, c("Chromosome", "Start_position", "End_position"))
#' }
#'
#' # Example 2
#'
#' \dontrun{
#' library(RTCGA.mutations)
#' data(UCS.mutations)
#' extractMutationData(UCS.mutations)
#' }
#'
#' @import dplyr
#' @export
extractMutationData <- function(mutation_data, selected_columns = c("Chromosome", "Start_position", "End_position",
                                                                    "Variant_Type", "Reference_Allele", "Tumor_Seq_Allele1",
                                                                    "Tumor_Sample_Barcode")) {
  # Validate that the 'mutation_data' input is a data frame
  if (!is.data.frame(mutation_data)) {
    stop("Input data must be a data frame.")
  }

  # Validate that the selected columns are within the data frame
  if (!all(selected_columns %in% colnames(mutation_data))) {
    stop("One or more specified columns do not exist in the data frame.")
  }

  # Select the specified columns from the data frame
  selected_data <- mutation_data %>% select(all_of(selected_columns))

  # Return the selected data
  return(selected_data)
}
