library(shiny)
library(ggplot2)
library(dplyr)

ui <- page_fluid(
  titlePanel("Mutation Data Visualization App"),
  navset_card_tab(
    # Home tab
    nav_panel("Home",
              div(class = "card", htmlOutput("homeContent"))
    ),

    # Bar Plot tab
    nav_panel("Bar Plot",
              "Visualize Mutation Frequency with a Bar Plot",
              page_sidebar(
                sidebar = sidebar("Input & Parameters",
                                  fileInput("mutationDataBP",
                                            "Upload Mutation Data in CSV format"),
                                  selectInput("groupByColumn",
                                              "Group by Column:",
                                              choices = NULL),
                                  actionButton("runBarPlot", "Generate Bar Plot")
                ),
                card("Bar Plot of Mutation Frequency",
                     plotOutput("barPlot"),
                     downloadButton("downloadBarPlot", "Download Bar Plot"))
              )
    ),

    # Heatmap tab
    nav_panel("Heatmap",
              "Visualize Mutation Frequency with a Heatmap",
              page_sidebar(
                sidebar = sidebar("Input & Parameters",
                                  fileInput("mutationDataHM",
                                            "Upload Mutation Data in CSV format"),
                                  selectizeInput("groupByColumns",
                                                 "Group by Columns (Select 2):",
                                                 choices = NULL,
                                                 multiple = TRUE,
                                                 options = list(maxItems = 2)),
                                  actionButton("runHeatmap", "Generate Heatmap")
                ),
                card("Heatmap of Mutation Frequency",
                     plotOutput("heatmapPlot"),
                     downloadButton("downloadHeatmap", "Download Heatmap"))
              )
    )
  ),
  id = "tab"
)

server <- function(input, output, session) {
  # Home
  output$homeContent <- renderUI({
    rmdFile <- "./homeContent.Rmd"
    renderedHTML <- rmarkdown::render(rmdFile,
                                      output_format = "html_fragment",
                                      quiet = TRUE)
    HTML(readLines(renderedHTML, warn = FALSE))
  })

  # Bar Plot
  observeEvent(input$mutationDataBP, {
    req(input$mutationDataBP)
    mutationData <- read.csv(input$mutationDataBP$datapath, stringsAsFactors = FALSE)
    updateSelectInput(session, "groupByColumn", choices = names(mutationData))
  })

  observeEvent(input$runBarPlot, {
    req(input$mutationDataBP, input$groupByColumn)
    mutationData <- read.csv(input$mutationDataBP$datapath, stringsAsFactors = FALSE)

    plot <- visualizeMutationFrequencyBar(mutationData, input$groupByColumn)

    output$barPlot <- renderPlot({ plot })

    output$downloadBarPlot <- downloadHandler(
      filename = "bar_plot.png",
      content = function(file) {
        ggsave(file, plot = plot, width = 8, height = 6)
      }
    )
  })

  # Heatmap
  observeEvent(input$mutationDataHM, {
    req(input$mutationDataHM)
    mutationData <- read.csv(input$mutationDataHM$datapath, stringsAsFactors = FALSE)
    updateSelectizeInput(session, "groupByColumns", choices = names(mutationData))
  })

  observeEvent(input$runHeatmap, {
    req(input$mutationDataHM, input$groupByColumns)
    if (length(input$groupByColumns) != 2) {
      showNotification("Please select exactly 2 columns for the heatmap.", type = "error")
      return(NULL)
    }

    mutationData <- read.csv(input$mutationDataHM$datapath, stringsAsFactors = FALSE)

    plot <- visualizeMutationFrequencyHeatmap(mutationData, input$groupByColumns)

    output$heatmapPlot <- renderPlot({ plot })

    output$downloadHeatmap <- downloadHandler(
      filename = "heatmap_plot.png",
      content = function(file) {
        ggsave(file, plot = plot, width = 8, height = 6)
      }
    )
  })
}

shinyApp(ui = ui, server = server)
