#' Extract Specific Columns from Mutation Data
#'
#' This function extracts specified columns from a dataset containing genetic mutation data. It's tailored to handle data in Mutation Annotation Format (MAF) or similar structured data frames, which are typical outputs of genomic studies such as those from TCGA. This function simplifies the process of selecting specific mutation-related attributes for further analysis.
#'
#' @param mutation_data A data frame containing detailed cancer mutation information. It should be structured with columns that can include various mutation attributes. This data frame is expected to be sourced from genomic studies databases like TCGA, pre-loaded into the R environment using the `data()` function.
#' @param selected_columns A character vector specifying the columns to be extracted. The default selection includes key mutation attributes commonly analyzed in genomic research:
#'        \itemize{
#'          \item \code{"Chromosome"}: The chromosome number where the mutation is located.
#'          \item \code{"Start_position"}: The genomic start position of the mutation.
#'          \item \code{"End_position"}: The genomic end position of the mutation.
#'          \item \code{"Variant_Type"}: The type of genetic variation (e.g., SNP, deletion).
#'          \item \code{"Reference_Allele"}: The reference allele at the mutation position.
#'          \item \code{"Tumor_Seq_Allele1"}: The allele in the tumor sample.
#'          \item \code{"Genome_Change"}: A description of the genomic alteration.
#'          \item \code{"Tumor_Sample_Barcode"}: Identifier for the tumor sample.
#'        }
#'
#' @return A data frame containing only the selected columns, facilitating focused analysis on specific mutation attributes.
#'
#' @examples
#' \dontrun{
#' library(RTCGA.mutations)
#' data(UCS.mutations) # Load the UCS.mutations dataset from the RTCGA.mutations package. This dataset contains mutation data for uterine carcinosarcoma and is used here to demonstrate data extraction.
#' extractMutationData(UCS.mutations, c("Chromosome", "Start_position", "End_position"))
#' # This example extracts the Chromosome, Start_position, and End_position columns from the UCS.mutations dataset to analyze genomic intervals.
#'
#' extractMutationData(UCS.mutations)
#' # In this example, the function uses default parameters to extract a broader set of mutation characteristics for initial explorations or broader analyses.
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
#' This function filters mutation data based on a set of user-defined conditions applied to specific columns of the dataset.
#' It allows for flexible data querying, enabling users to filter mutation records by one or more attributes such as chromosome number,
#' mutation type, gene symbol, etc. The function supports both single value matching and range conditions, making it highly versatile
#' for exploring and subsetting genetic data for further analysis.
#'
#' @param data A data frame containing mutation data, such as `UCS.mutations`, which typically includes detailed records
#'             of genetic mutations identified in cancer studies. This data frame must have structured columns where mutations
#'             are detailed by various descriptors (e.g., Chromosome, Gene Symbol, Mutation Type).
#' @param conditions A list of conditions to filter by, where each element is named by a column name in the `data` data frame and
#'                   contains the values or range to filter on. The conditions should be provided in a named list format where
#'                   each name corresponds to a column in `data` and the associated value defines the filtering criterion.
#'                   Examples include:
#'                   - Single value condition: `list(Chromosome = "1")` filters data for mutations on chromosome 1.
#'                   - Range condition: `list(Start_position = c(100000, 200000))` filters mutations occurring between these positions.
#'                   - Multiple values condition: `list(Gene = c("TP53", "BRCA1"))` filters data for mutations in either TP53 or BRCA1 genes.
#'
#' @return A filtered data frame that matches the specified conditions. Each row in the returned data frame corresponds to a mutation
#'         record that meets all the filtering criteria specified in `conditions`. This makes it suitable for subsequent genetic
#'         analysis or reporting.
#'
#' @examples
#' \dontrun{
#' # Example 1: Filter by chromosome and variant type
#' library(RTCGA.mutations)
#' data(UCS.mutations)
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Chromosome = "1", Variant_Type = "SNP"))
#' # This example filters the UCS.mutations dataset for mutations located on chromosome 1 that are classified as SNPs (single nucleotide polymorphisms).
#'
#' # Example 2: Filter by a specific gene symbol
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(Hugo_Symbol = "TP53"))
#' # Filters for mutations associated with the TP53 gene, known to play a role in cancer suppression.
#'
#' # Example 3: Filtering by multiple conditions for a single column
#' filtered_data <- filterMutations(UCS.mutations, conditions = list(
#' Hugo_Symbol = c("IPO11", "CALR"),
#' Variant_Type = "SNP"))
#' # This filters for mutations that are in either the IPO11 or CALR genes and are SNPs, demonstrating how to use multiple conditions for more refined filtering.
#' }
#'
#' @export
filterMutations <- function(data, conditions) {
  # Validate conditions input
  if (is.null(conditions) || length(conditions) == 0) {
    stop("Please provide a list of conditions to filter by.")
  }

  # Check if all specified columns exist in the data frame
  for (col in names(conditions)) {
    if (!col %in% names(data)) {
      stop(paste("Column", col, "not found in the data."))
    }
  }

  # Apply each condition to filter the data
  for (col in names(conditions)) {
    condition <- conditions[[col]]

    # Apply filtering based on the type of condition
    if (is.vector(condition)) {
      data <- data[data[[col]] %in% condition, ]
    } else if (is.numeric(condition) && length(condition) == 2) {
      # Ensure numeric columns for range filtering
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
