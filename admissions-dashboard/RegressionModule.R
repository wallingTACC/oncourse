#Shiny module 

# UI function
modelUI <- function(id) {
  # Create a namespace function using the provided id
  ns <- NS(id)
  
  fillCol(height = 600, flex = c(NA, 1), 
          inputPanel(
            selectInput("grad_type", label = "GradType",
                        choices = as.factor(c('low', 'mid', 'high')), selected = 'low')
          ),
          plotOutput(ns("predPlot"), height = "100%")
  )
}

# Server function
modelServer <- function(input, output, session) {
  
  output$predPlot <- renderPlot({
    pred_data <- data.frame(grad_type=input$grad_type,
                            num_adv=2,
                            gpa=3.5)
    prediction <- predict(model, newdata=pred_data)
    plot(prediction)
  })
}