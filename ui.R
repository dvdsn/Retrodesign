#
# This is the user-interface definition of a Shiny web application for 
# calculating and plotting Type M and Type S error rates. You can
# run the application by clicking 'Run App' above.
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel(" "),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(

      em("Choose upper and lower bounds of effect size."),
      br(),
      sliderInput("A",
                  "Effect size range",
                  min = 0.1, 
                  max = 30.0, 
                  value = c(1, 5)),
      br(),
      
      em("Choose values of s, alpha, df, and 
         n.sims to reflect external information 
         about your design or simulation."),
      br(),
      sliderInput("s",
                  "Standard error:",
                  min = 0.1,
                  max = 20.0,
                  value = 2),
      
      sliderInput("alpha",
                  "Alpha:",
                  min = 0.0001,
                  max = 0.05,
                  value = 0.05,
                  step = 0.001),
      
      sliderInput("df",
                  "Degrees of freedom:",
                  min = 2,
                  max = 100,
                  value = 30,
                  step = 1,
                  round = TRUE),
      
      sliderInput("n.sims",
                  "Number of simulations:",
                  min = 100,
                  max = 2000,
                  value = 500,
                  step = 100,
                  round = TRUE),
      
      submitButton("Submit")
      
      ),

    
    # Show plots of the power and type-M/S
    mainPanel(
      h1("Type S and Type M Error Rates"),
      plotOutput("xyPlot")
    )
  )
))
