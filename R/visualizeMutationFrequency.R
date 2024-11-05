#' Visualize Mutation Frequency with a Bar Plot
#'
#' This function generates a bar plot showing the frequency of mutations based on a specified column.
#' It is ideal for visualizing the distribution of mutations by a single category, such as chromosome or allele type.
#'
#' @param data A data frame containing mutation data, which must include the specified grouping column.
#' @param group_by_column A character string specifying the column to group by for mutation frequency counts.
#'
#' @return A ggplot2 object showing a bar plot with the specified grouping column on the x-axis and
#'         the mutation frequency on the y-axis.
#'
#' @examples
#' \dontrun{
#'
#' # Example 1
#' # Visualize mutation frequency by chromosome
#' visualizeMutationFrequencyBar(UCS.mutations, group_by_column = "Chromosome")
#'
#' Example 2
#' visualizeMutationFrequencyBar(filteredUCSFirst100SNP, group_by_column = "SNP_Mutation")
#' }
#'
#' @import ggplot2
#' @import dplyr
#' @export
visualizeMutationFrequencyBar <- function(data, group_by_column) {
  # Check if the specified column exists in the data
  if (!group_by_column %in% names(data)) {
    stop("The specified grouping column does not exist in the data.")
  }

  # Count the frequency of mutations by the specified column
  mutation_counts <- data %>%
    dplyr::count(!!rlang::sym(group_by_column), name = "Frequency") %>%
    dplyr::arrange(!!rlang::sym(group_by_column))  # Sort by the grouping column

  # Note: line 34 - 35 are suggested by chatGPT: "!!rlang::sym(group_by_column): This evaluates group_by_column
  # correctly within dplyr::count() by using !! (pronounced "bang-bang") to unquote it. This allows it to be
  # interpreted as a column name rather than as a symbol."


  # Convert x-axis to factor and order levels
  mutation_counts[[group_by_column]] <- factor(mutation_counts[[group_by_column]],
                                               levels = sort(unique(mutation_counts[[group_by_column]])))

  # Create a bar plot using aes() with tidy evaluation
  plot <- ggplot2::ggplot(mutation_counts, ggplot2::aes(x = !!rlang::sym(group_by_column), y = Frequency)) +
    ggplot2::geom_bar(stat = "identity", fill = "steelblue") +
    ggplot2::labs(
      title = paste("Mutation Frequency by", group_by_column),
      x = group_by_column,
      y = "Mutation Frequency"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  # Return the plot
  return(plot)
}


#' Visualize Mutation Frequency with a Heatmap
#'
#' This function creates a heatmap to visualize mutation frequency based on two specified columns,
#' such as `Reference_Allele` and `Tumor_Seq_Allele2`. Rows with values other than single-letter bases
#' in either column are excluded.
#'
#' @param data A data frame containing mutation data, which must include the two specified grouping columns.
#' @param group_by_columns A character vector of exactly two column names to group by for mutation frequency counts.
#'        These columns must contain only nucleotide bases (e.g., "A", "T", "C", "G").
#'
#' @return A ggplot2 object showing a heatmap with one column on the x-axis and the other on the y-axis.
#'         The color intensity represents the frequency of mutations.
#'
#' @examples
#' \dontrun{
#' # Visualize mutation frequency by Reference and Tumor alleles
#' visualizeMutationFrequencyHeatmap(UCS.mutations, group_by_columns = c("Reference_Allele", "Tumor_Seq_Allele2"))
#' }
#'
#' @import ggplot2
#' @import dplyr
#' @export
visualizeMutationFrequencyHeatmap <- function(data, group_by_columns) {
  # Ensure group_by_columns is a vector of exactly two column names
  if (length(group_by_columns) != 2) {
    stop("Please specify exactly two column names for the heatmap.")
  }

  # Check if the specified columns exist in the data
  if (!all(group_by_columns %in% names(data))) {
    stop("One or more specified columns do not exist in the data.")
  }
  # Note: the following are suggested by chatGPT: "!!rlang::sym(group_by_column): This evaluates group_by_column
  # correctly within dplyr::count() by using !! (pronounced "bang-bang") to unquote it. This allows it to be
  # interpreted as a column name rather than as a symbol."

  # Filter rows to include only those with single-letter bases in both columns
  data_filtered <- data %>%
    dplyr::filter(nchar(!!rlang::sym(group_by_columns[1])) == 1,
                  nchar(!!rlang::sym(group_by_columns[2])) == 1)

  # Count the frequency of mutations by the specified columns
  mutation_counts <- data_filtered %>%
    dplyr::count(!!rlang::sym(group_by_columns[1]), !!rlang::sym(group_by_columns[2]), name = "Frequency") %>%
    dplyr::arrange(!!rlang::sym(group_by_columns[1]), !!rlang::sym(group_by_columns[2]))

  # Convert x-axis and y-axis columns to factors with sorted levels
  mutation_counts[[group_by_columns[1]]] <- factor(mutation_counts[[group_by_columns[1]]],
                                                   levels = sort(unique(mutation_counts[[group_by_columns[1]]])))
  mutation_counts[[group_by_columns[2]]] <- factor(mutation_counts[[group_by_columns[2]]],
                                                   levels = sort(unique(mutation_counts[[group_by_columns[2]]])))

  # Create a heatmap
  plot <- ggplot2::ggplot(mutation_counts, ggplot2::aes(x = !!rlang::sym(group_by_columns[1]),
                                                        y = !!rlang::sym(group_by_columns[2]), fill = Frequency)) +
    ggplot2::geom_tile(color = "white") +
    ggplot2::scale_fill_gradient(low = "lightblue", high = "steelblue") +
    ggplot2::labs(
      title = paste("Mutation Frequency by", group_by_columns[1], "and", group_by_columns[2]),
      x = group_by_columns[1],
      y = group_by_columns[2],
      fill = "Frequency"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  # Return the plot
  return(plot)
}
