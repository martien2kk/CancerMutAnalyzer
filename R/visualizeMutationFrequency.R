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
#' visualizeMutationFrequencyBar(UCS.mutation, group_by_column = "Chromosome")
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
    count(!!sym(group_by_column), name = "Frequency") %>%
    arrange(!!sym(group_by_column))  # Sort by the grouping column

  # Convert x-axis to factor and order levels
  mutation_counts[[group_by_column]] <- factor(mutation_counts[[group_by_column]],
                                               levels = sort(unique(mutation_counts[[group_by_column]])))

  # Create a bar plot
  plot <- ggplot(mutation_counts, aes_string(x = group_by_column, y = "Frequency")) +
    geom_bar(stat = "identity", fill = "steelblue") +
    labs(
      title = paste("Mutation Frequency by", group_by_column),
      x = group_by_column,
      y = "Mutation Frequency"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

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

  # Filter rows to include only those with single-letter bases in both columns
  data_filtered <- data %>%
    filter(nchar(!!sym(group_by_columns[1])) == 1,
           nchar(!!sym(group_by_columns[2])) == 1)

  # Count the frequency of mutations by the specified columns
  mutation_counts <- data_filtered %>%
    count(!!sym(group_by_columns[1]), !!sym(group_by_columns[2]), name = "Frequency") %>%
    arrange(!!sym(group_by_columns[1]), !!sym(group_by_columns[2]))  # Sort by both grouping columns

  # Convert x-axis and y-axis columns to factors with sorted levels
  mutation_counts[[group_by_columns[1]]] <- factor(mutation_counts[[group_by_columns[1]]],
                                                   levels = sort(unique(mutation_counts[[group_by_columns[1]]])))
  mutation_counts[[group_by_columns[2]]] <- factor(mutation_counts[[group_by_columns[2]]],
                                                   levels = sort(unique(mutation_counts[[group_by_columns[2]]])))

  # Create a heatmap
  plot <- ggplot(mutation_counts, aes_string(x = group_by_columns[1], y = group_by_columns[2], fill = "Frequency")) +
    geom_tile(color = "white") +
    scale_fill_gradient(low = "lightblue", high = "steelblue") +
    labs(
      title = paste("Mutation Frequency by", group_by_columns[1], "and", group_by_columns[2]),
      x = group_by_columns[1],
      y = group_by_columns[2],
      fill = "Frequency"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  # Return the plot
  return(plot)
}
