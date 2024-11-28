library(shiny)
library(ggplot2)
library(dplyr)

# Define UI
ui <- navbarPage(title = "Visualize Mutation Frequencies",
                 tabPanel("Bar Plot",
                          sidebarLayout(
                            sidebarPanel(
                              tags$h3("About This App"),
                              tags$p("This Shiny app visualizes mutation frequencies using bar plots and heatmaps. It allows for interactive selection of data categories and provides options to upload your own datasets in CSV or RDA formats."),
                              br(),
                              tags$h4("Instructions:"),
                              tags$p("1. Use the dropdown to select a column to group by for the bar plot."),
                              tags$p("2. Check the boxes to filter which categories to display."),
                              tags$p("3. Click 'Generate Bar Plot' to see the results."),
                              tags$p("4. Upload your own data using the controls below or download and use the example dataset."),
                              br(),
                              tags$h4("Download Example Dataset"),
                              tags$p("The example dataset, filteredUCSFirst100SNP.rda, includes mutation data filtered for specific SNP characteristics. Specifically, it includes the first 100 Single Nucleotide Polymorphism Mutations In The UCS.mutations Dataset. UCS Stands for Uterine Carcinosarcoma, and it is from The Cancer Genome Atlas Project 2015-11-01 snapshot. This dataset is ideal for demonstrating the functionalities of this app."),
                              tags$a(href = "https://github.com/martien2kk/CancerMutAnalyzer/raw/master/data/filteredUCSFirst100SNP.rda",
                                     "Download filteredUCSFirst100SNP.rda", target = "_blank"),
                              br(),
                              selectInput("group_by_column", "Select Column to Group By for Bar Plot:",
                                          choices = NULL),
                              uiOutput("checkboxes"),
                              actionButton("plot_bar", "Generate Bar Plot"),
                              fileInput("fileUpload", "Upload Your Own Data (CSV or RDA)", accept = c(".csv", ".rda"))
                            ),
                            mainPanel(
                              plotOutput("barPlot")
                            )
                          )),
                 tabPanel("Heatmap for Allele Frequencies",
                          sidebarLayout(
                            sidebarPanel(
                              tags$h3("Heatmap Generation"),
                              tags$p("This tab generates a heatmap for allele frequencies, specifically analyzing 'Reference_Allele' and 'Tumor_Seq_Allele2'."),
                              actionButton("plot_heatmap", "Generate Heatmap")
                            ),
                            mainPanel(
                              plotOutput("heatmapPlot")
                            )
                          ))
)

# Define server logic
server <- function(input, output, session) {
  # Reactive expression to handle data loading
  data <- reactiveVal()  # Initialize with no data

  observeEvent(input$fileUpload, {
    req(input$fileUpload)
    inFile <- input$fileUpload

    if (grepl("\\.rda$", inFile$name)) {
      load(inFile$datapath)  # Load the RDA file
      data(get(ls()[1]))  # Assume the RDA file contains one main dataset
    } else if (grepl("\\.csv$", inFile$name)) {
      data <- read.csv(inFile$datapath)  # Load a CSV file
    }

    updateSelectInput(session, "group_by_column", choices = setdiff(names(data()), c("Start_position", "Tumor_Sample_Barcode")))
  })

  observe({
    req(data())  # Make sure data is loaded
    output$checkboxes <- renderUI({
      choices <- unique(data()[[input$group_by_column]])
      sorted_choices <- sort(choices, method="radix")
      checkboxGroupInput("selected_values", "Select Values:", choices = sorted_choices, selected = sorted_choices)
    })
  })

  observeEvent(input$plot_bar, {
    req(data())
    output$barPlot <- renderPlot({
      if (length(input$selected_values) > 0) {
        filtered_data <- data() %>%
          filter(.[[input$group_by_column]] %in% input$selected_values)
        visualizeMutationFrequencyBar(filtered_data, input$group_by_column)
      } else {
        ggplot() + ggtitle("No data to display - select at least one value")
      }
    })
  })

  # Heatmap specific to allele columns
  observeEvent(input$plot_heatmap, {
    req(data())
    output$heatmapPlot <- renderPlot({
      visualizeMutationFrequencyHeatmap(data(), c("Reference_Allele", "Tumor_Seq_Allele2"))
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
