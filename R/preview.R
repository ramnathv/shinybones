#' Preview a shiny module in a shiny dashboard
#'
#' @param module_name Name of the module
#' @param name Namespace to call the module
#' @param ... Additional parameters to pass to the module
#' @import shinydashboard
#' @importFrom purrr possibly
#' @export
#' @examples
#' slider_text_ui <- function(id){
#'   ns <- NS(id)
#'   tagList(
#'     sliderInput(ns('num'), 'Enter Number', 0, 1, 0.5),
#'     textOutput(ns('num_text'))
#'   )
#' }
#' slider_text <- function(input, output, session){
#'    output$num_text <- renderText({input$num})
#' }
#' preview_module('slider_text')
preview_module <- function(module_name, name = 'module', ...){
  ui_fun <- match.fun(paste(module_name, 'ui', sep = "_"))
  sidebar_ui_fun <- purrr::possibly(match.fun, function(x){NULL})(
    paste0(module_name, '_ui_sidebar')
  )
  mod_fun <- match.fun(module_name)
  ui <- dashboardPage(
    dashboardHeader(title = name),
    dashboardSidebar(
      sidebar_ui_fun(name)
    ),
    dashboardBody(
      ui_fun(name, ...)
    )
  )
  server <- function(input, output, session){
    module_output <- shiny::callModule(
      mod_fun, name, ...
    )
  }
  shiny::shinyApp(ui = ui, server = server)
}