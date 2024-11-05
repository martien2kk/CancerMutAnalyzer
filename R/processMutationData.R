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


#' Filter Mutation Data by Specified Conditions
#'
#' This function filters mutation data based on user-specified conditions for any columns in the dataset.
#'
#' @param data A data frame containing mutation data, such as `UCS.mutations`.
#' @param conditions A list of conditions to filter by, where each element is named with a column name
#'                   and contains the value or range to filter on. Example: `list(Chromosome = "1", Variant_Type = "SNP")`.
#' @return A filtered data frame that matches the specified conditions.
#'
#' @examples
#' \dontrun{
#' # Filter by chromosome and variant type
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Chromosome = "1", Variant_Type = "SNP"))
#'
#' # Filter by start position range and a specific gene symbol
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Start_position = c(100000, 200000), Hugo_Symbol = "TP53"))
#' }
#'
#' @export
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

