#' Launch Shiny App For Package CancerMutAnalyzer
#'
#' A function that launches the Shiny app for CancerMutAnalyzer
#' This app will allow users to create visualisations of Mutation Frequency
#' based on different clinical attributes.
#' The code has been placed in \code{./inst/shiny-scripts}.
#'
#' @return No return value but open up a shiny page.
#'
#' @examples
#' \dontrun{
#' runCancerMutAnalyzer()
#' }
#'
#' @author Keren Zhang, \email{keren.zhang@utoronto.ca}
#'
#' @references
#' Grolemund, G. (2015). Learn Shiny - Video Tutorials. \href{https://shiny.rstudio.com/tutorial/}{Link}
#'
#' @export
#' @importFrom shiny runApp
runCancerMutAnalyzer <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "CancerMutAnalyzer")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
