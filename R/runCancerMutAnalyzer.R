#' Launch Shiny App For Package CancerMutAnalyzer
#'
#' A function that launches the shiny app for this package.
#' The shiny app permit to perform
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
#'
#'
#' @export
#' @importFrom shiny runApp
runMPLNClust <- function() {
  appDir <- system.file("shiny-scripts",
                        package = "CancerMutAnalyzer")
  shiny::runApp(appDir, display.mode = "normal")
  return()
}
