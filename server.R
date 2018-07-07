# Interactive plot

library(shiny)

# Define a function for calculations, from Gelman and Carlin (2014)
retrodesign <- function(A, s, alpha=.05, df=Inf, n.sims=10000){
  
  z <- qt(1-alpha/2, df)
  p.hi <- 1 - pt(z-A/s, df)
  p.lo <- pt(-z-A/s, df)
  power <- p.hi + p.lo
  typeS <- p.lo/power
  estimate <- A + s*rt(n.sims,df)
  significant <- abs(estimate) > s*z
  exaggeration <- mean(abs(estimate)[significant])/A
  
  return( list(power=power, 
               typeS=typeS, 
               exaggeration=exaggeration))
}

# Define server logic required to draw a plot
shinyServer(function(input, output) {

  output$xyPlot <- renderPlot({

    # Variables for plot
    lower <- input$A[1]
    upper <- input$A[2]
    #D_range <- c(seq(0,1,.01), seq(1,10,.1), 11)
    D_range <- c(seq(lower, upper, 0.1))
    n <- length(D_range) 
    power <- rep(NA, n)
    typeS <- rep(NA, n)
    exaggeration <- rep(NA, n)
    for (i in 1:n){
      
      a <- retrodesign(D_range[i], 
                       input$s, 
                       input$alpha, 
                       input$df, 
                       input$n.sims)
      
      power[i] <- a$power
      typeS[i] <- a$typeS
      exaggeration[i] <- a$exaggeration
    }
    
    # Plots
    par(mfrow=c(1,2))
    
    plot(power, 
         typeS, 
         type="l", 
         xlim=c(0, 1.05), 
         ylim=c(0,0.1), 
         xaxs="i", 
         yaxs="i",
         xlab="Power", 
         ylab="Type S error rate", 
         cex.axis=1, 
         cex.lab=1,
         cex.main=0.9,
         main="Probability that estimate has wrong sign")
    
    axis(2, c(0,5,10))
    segments(.05, 1, 1, 1, col="grey")
    
    plot(power, 
         exaggeration,  
         type="l", 
         xlim=c(0, 1.05), 
         ylim=c(0.8, 5), 
         xaxs="i", 
         yaxs="i",
         xlab="Power", 
         ylab="Exaggeration ratio",
         cex.axis=1, 
         cex.lab=1,
         cex.main=0.9,
         main="Exaggeration ratio of effect size")
    abline(h=1, col="grey")
    
    
    
  })
  
})
