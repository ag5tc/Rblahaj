# This Shiny app takes the scraped IKEA product reviews,
# and shows the viewer a random review for BLÅHAJ

# import packages
library(tidyverse)
library(shiny)

# read in data
load("output.RData")

# coerce tibble to data frame to avoid errors:
# can't subset tibble using an integer of class "shinyActionButtonValue"
# should not make a noticeable difference
data <- data.frame(data)

# add a column with stars
star <- "\U2B50"
data$stars <- apply(
  data, 
  1, 
  function(x) str_flatten(rep.int(star, x["rating"])), 
  simplify = TRUE
)

# helper function to make it random
get_field <- function(index, column, order) {
    data_ordered <- data[order,]
    return(data_ordered[[index, column]])
}

# Define UI for application
# very simple
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
            h3(textOutput("author")),
            h4(textOutput("date")),
            h4(textOutput("location")),
            h2(textOutput("title")),
            p(textOutput("review")),
        )
    )
)

# Define server logic
server <- function(input, output) {
  # randomly sort the data frame for this "user,"
  # since the server runs once per session
  order <- sample(nrow(data))
  
  # every time the "I'm Feeling Lucky" button is pressed,
  # input$button is iterated,
  # and new data is displayed
  observeEvent(input$button, {
    
    output$stars <- renderText({
      get_field(input$button, "stars", order)
    })
    
    output$author <- renderText({
      get_field(input$button, "name", order)
    })
    
    output$date <- renderText({
      as.character.Date(get_field(input$button, "date", order))
    })
    
    output$location <- renderText({
      get_field(input$button, "location", order)
    })
    
    output$title <- renderText({
      get_field(input$button, "title", order)
    })
    
    output$review <- renderText({
      get_field(input$button, "review_text", order)
    })
    
  })

}

# Run the application 
shinyApp(ui = ui, server = server)
