#' Extract Specific Columns from Mutation Data
#'
#' This function extracts specified columns from a mutation data set. It has default settings
#' for commonly used columns but allows for user customization. It checks whether the input
#' is a data frame and whether the specified columns exist in the data frame.
#'
#' @param mutation_data Cancer mutation data in Mutation Annotation Format (MAF) or data frame format.
#' @param selected_columns A character vector specifying the columns to be extracted from the
#'        mutation_data data frame. Default columns are:
#'        \itemize{
#'          \item \code{"Chromosome"}: The chromosome number on which the mutation occurs.
#'          \item \code{"Start_position"}: The starting position of the mutation on the chromosome.
#'          \item \code{"End_position"}: The ending position of the mutation on the chromosome.
#'          \item \code{"Variant_Type"}: The type of mutation, such as single nucleotide polymorphisms (SNP), deletion, or insertion.
#'          \item \code{"Reference_Allele"}: The base(s) found on the reference allele at the position of the mutation.
#'          \item \code{"Tumor_Seq_Allele1"}: The base(s) found in the tumor sample at the mutation position.
#'          \item \code{"Genome_Change"}: A character vector specifying the genomic change at the mutation site, typically in the format
#'            "g.chr<chromosome>:<position><reference_base>>><mutated_base>". For example, "g.chr5:61733126G>T" indicates
#'            a mutation on chromosome 5 at position 61733126, where the reference base "G" has been mutated to "T".
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
#'
#' @references
#' Kosinski M (2024). _RTCGA.mutations: Mutations datasets from The Cancer Genome Atlas Project_.
#' doi:10.18129/B9.bioc.RTCGA.mutations <https://doi.org/10.18129/B9.bioc.RTCGA.mutations>, R package version
#' 20151101.34.0, <https://bioconductor.org/packages/RTCGA.mutations>.
#'
#' R Core Team (2024). _R: A Language and Environment for Statistical Computing_. R Foundation for Statistical
#' Computing, Vienna, Austria. <https://www.R-project.org/>.
#'
#' Wickham H, François R, Henry L, Müller K, Vaughan D (2023). _dplyr: A Grammar of Data Manipulation_. R
#' package version 1.1.4, <https://CRAN.R-project.org/package=dplyr>.
#'
#' @export
extractMutationData <- function(mutation_data, selected_columns = c("Chromosome", "Start_position", "End_position",
                                                                    "Variant_Type", "Reference_Allele", "Tumor_Seq_Allele1",
                                                                    "Genome_Change", "Tumor_Sample_Barcode")) {
  # Validate that the 'mutation_data' input is a data frame
  if (!is.data.frame(mutation_data)) {
    stop("Input data must be a data frame.")
  }

  # Validate that the selected columns are within the data frame
  if (!all(selected_columns %in% colnames(mutation_data))) {
    stop("One or more specified columns do not exist in the data frame.")
  }

  # Select the specified columns from the data frame using dplyr::select
  selected_data <- dplyr::select(mutation_data, dplyr::all_of(selected_columns))

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
#'
#' # Example 1
#' # Filter by chromosome and variant type
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Chromosome = "1", Variant_Type = "SNP"))
#' filtered_data
#'
#' # Example 2
#' # Filter by a specific gene symbol
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Hugo_Symbol = "TP53"))
#' }
#'
#' # Example 3
#' # Filtering by multiple conditions for a single column, like 2 Hugo_Symbol values and a single Variant_Type
#' filterMutations(subset_UCS_data, conditions = list(
#' Hugo_Symbol = c("IPO11", "CALR"),
#' Variant_Type = "SNP"))
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
    if (is.vector(condition)) {
      # Multiple values: Match any of the values
      data <- data[data[[col]] %in% condition, ]
    } else if (is.numeric(condition) && length(condition) == 2) {
      # Range filtering for numeric columns
      if (is.numeric(data[[col]])) {
        data <- data[data[[col]] >= condition[1] & data[[col]] <= condition[2], ]
      } else {
        stop(paste("Range filtering is only applicable to numeric columns. Column", col, "is not numeric."))
      }
    } else {
      stop("Invalid condition format. Use a vector for multiple values or a two-element numeric vector for range filtering.")
    }
  }

  return(data)
}
