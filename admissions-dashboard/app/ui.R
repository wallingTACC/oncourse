library(shiny)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Miles Per Gallon"),
  
  sidebarPanel(
    sliderInput("gpa",
                "GPA:",
                min = 0.0,
                max = 4.0,
                value = 3.0)
  ),
  
  mainPanel()
))
