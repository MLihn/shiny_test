library(shiny)
library(shinythemes)
library(tidyverse)
library(readxl)

passat <- read_excel("passat.xlsx")


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Min shiny APP", title = div(img(height = 100, width = 120, src = "sif_logo.png"))),

    theme = shinytheme("cosmo"),
    
    headerPanel("Dataanalyse"),
    
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        
        sidebarPanel("Sidebar",
                     selectInput("xaxis", label = "Vælg x-akse", choices = names(passat), selected = "km_per_liter", TRUE, multiple = FALSE),
                    selectInput("yaxis",  label = "Vælg y-akse", choices = names(passat), multiple = FALSE),
                    selectInput("data_input", label = "Vælg datasæt", choices = c("mtcars", "faithful", "iris"))),
        # Show a plot of the generated distribution
        mainPanel("",
                  tabsetPanel(id = "tabs",
                              tabPanel("Plot", plotOutput("plot1")),
                              tabPanel("Tabel", plotOutput("tabel")))
                  )
        
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot1 <- renderPlot({
        
        ggplot(data = passat, aes_string(as.name(input$xaxis), y = as.name(input$yaxis))) +
                   geom_point()
        
    })
    
    getdata <- reactive({
        
    get(input$data_input, "package:datasets")
        
    })
    
    output$tabel <- renderTable({head(getdata()}))
}

# Run the application 
shinyApp(ui = ui, server = server)
