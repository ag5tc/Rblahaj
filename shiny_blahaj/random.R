#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# SHOWS A RANDOM BLAHAJ REVIEW

library(shiny)

##initialize data
load("output_sandbox.RData")
blahaj <- function(index, column, order) {
    data_ordered <- data[order,]
    return(data_ordered[index, column])
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel(
        title = "a BLÅHAJ a day keeps the rona away",
        windowTitle = "random BLÅHAJ generator"
    ),
    
    sidebarLayout(
        sidebarPanel(
            img(src = "blahaj-side-inverse.png", width = "40%"),
            actionButton("button", label = "I'm Feeling Lucky"),
        ),
        
        mainPanel(
            img(src = "blahaj-hi-transp.png", 
                width = "50%",
                style = "float:right"),
            h2(textOutput("stars")),
            h4(textOutput("author")),
            h4(textOutput("date")),
            h2(textOutput("title")),
            p(textOutput("review")),
        )
    )
)


# Define server logic ----
server <- function(input, output) {
    order <- sample(nrow(data))
    
    output$stars <- renderText({ 
        blahaj(input$button, 6, order)
    })
    
    output$author <- renderText({ 
        blahaj(input$button, 1, order)
    })
    
    output$date <- renderText({ 
        blahaj(input$button, 2, order)
    })
    
    output$title <- renderText({ 
        blahaj(input$button, 4, order)
    })
    
    output$review <- renderText({
        blahaj(input$button, 5, order)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
