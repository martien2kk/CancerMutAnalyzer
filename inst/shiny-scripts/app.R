library(shiny)
library(ggplot2)
library(dplyr)

# Load the mutation data
load("./data/filteredUCSFirst100SNP.rda")  # Adjust path if necessary

# Define UI
ui <- navbarPage(title = "Visualize Mutation Frequencies",
                 tabPanel("Bar Plot For Mutation Frequency",
                          sidebarLayout(
                            sidebarPanel(
                              selectInput("group_by_column", "Select Column to Group By for Bar Plot:",
                                          choices = setdiff(names(filteredUCSFirst100SNP), c("Start_position", "Tumor_Sample_Barcode"))),
                              uiOutput("checkboxes"),  # Output for dynamic checkbox group
                              actionButton("plot_bar", "Generate Bar Plot")
                            ),
                            mainPanel(
                              plotOutput("barPlot")
                            )
                          )),
                 tabPanel("Heatmap for Allele Frequencies",
                          sidebarLayout(
                            sidebarPanel(
                              actionButton("plot_heatmap", "Generate Heatmap")
                            ),
                            mainPanel(
                              plotOutput("heatmapPlot")
                            )
                          ))
)

# Define server logic
server <- function(input, output, session) {

  # Dynamic output for checkboxes based on selected column for bar plot
  output$checkboxes <- renderUI({
    choices <- unique(filteredUCSFirst100SNP[[input$group_by_column]])
    # Natural order sorting for strings and numbers
    sorted_choices <- sort(choices, method="radix")
    checkboxGroupInput("selected_values", "Select Values:", choices = sorted_choices, selected = sorted_choices)
  })

  observeEvent(input$plot_bar, {
    output$barPlot <- renderPlot({
      # Filter the data based on the checked values
      if (length(input$selected_values) > 0) {
        filtered_data <- filteredUCSFirst100SNP %>%
          filter(.[[input$group_by_column]] %in% input$selected_values)
        visualizeMutationFrequencyBar(filtered_data, input$group_by_column)
      } else {
        # Return an empty plot if no values are selected
        ggplot() + ggtitle("No data to display - select at least one value")
      }
    })
  })

  # Heatmap specific to allele columns
  observeEvent(input$plot_heatmap, {
    output$heatmapPlot <- renderPlot({
      # Directly specify the columns for heatmap
      visualizeMutationFrequencyHeatmap(filteredUCSFirst100SNP, c("Reference_Allele", "Tumor_Seq_Allele2"))
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
