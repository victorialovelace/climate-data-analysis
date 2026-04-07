library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(shiny)

data_us_cost <- read.csv("time-series-US-cost-1980-2025.csv")
data_us_cost_unadj <- read.csv("time-series-US-cost-1980-2025-unadj.csv")

ui <- fluidPage(
  titlePanel("Cost of U.S. Weather Disasters Exceeding $1 BN in Damages"),
  sidebarLayout(
    sidebarPanel(
      selectInput("disasters", "What disaster(s) would you like to include?", choices = c("Drought", "Flooding", "Freeze", "Severe Storm", "Tropical Cyclone", "Wildfire"), multiple = TRUE, selected = c("Drought", "Flooding", "Freeze", "Severe Storm", "Tropical Cyclone", "Wildfire")),
      checkboxInput("cpi", "Would you like to adjust for CPI?", value = TRUE),
      sliderInput("year_range", "Select a year range:", min = 1980, max = 2024, value = c(1980, 2024), sep = "")
    ),
    mainPanel(
      plotlyOutput("plot")
    )
  )
)

server <- function(input, output, session){
  output$plot <- renderPlotly({
    if(input$cpi){
      data <- data_us_cost
    }
    else{
      data <- data_us_cost_unadj
    }
    
    data <- data %>% 
      rename(
        Drought = Drought.Cost,
        Flooding = Flooding.Cost,
        Freeze = Freeze.Cost,
       `Severe Storm` = Severe.Storm.Cost,
       `Tropical Cyclone` = Tropical.Cyclone.Cost,
       Wildfire = Wildfire.Cost
          )
    
    filtered_data <- data %>%
      filter(Year >= input$year_range[1], Year <= input$year_range[2]) %>%
      select(Year, all_of(input$disasters)) %>%
      pivot_longer(-Year, names_to = "Disaster", values_to = "Cost")
    title_text = paste0("Total Cost of U.S. Disasters With Damages \nExceeding $1BN (", input$year_range[1], "-", input$year_range[2], ")")
    
    plot_ly(data = filtered_data, x = ~Year, y = ~Cost, color = ~Disaster, colors = c("#08306B","#2171B5","#6BAED6", "#4B0082","#9E9AC8","#6A5ACD"), type = "bar", hoverinfo = "text", hovertext = ~paste("Cost: $", Cost, "B")) %>% 
      layout(
        barmode = "stack",
        title = list(
          text = title_text
        ),
        yaxis = list(title = "Cost (Billions)")
      )
  })
}

shinyApp(ui, server)
