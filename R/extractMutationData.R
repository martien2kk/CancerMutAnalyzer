#' Extract Specific Columns from Mutation Data
#'
#' This function extracts specified columns from a mutation dataset. It checks whether the input
#' is a data frame and whether the specified columns exist in the data frame. It is assumed that
#' the dataset has been pre-loaded and is provided as an argument to the function.
#'
#' @param mutation_data A data frame containing mutation data.
#' @param selected_columns A character vector specifying the columns to be extracted from the
#' mutation_data data frame.
#'
#' @return Returns a data frame containing only the columns specified by the user.
#'
#' @examples
#' \dontrun{
#' library(RTCGA.mutations)
#' data(UCS.mutations)
#' extractMutationData(UCS.mutations, c("Chromosome", "Start_position", "End_position"))
#' }
#'
#' @import dplyr
#' @export
extractMutationData <- function(mutation_data, selected_columns) {
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
