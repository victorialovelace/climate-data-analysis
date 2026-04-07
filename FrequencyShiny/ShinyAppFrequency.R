library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(shiny)

frequency_billion <- read.csv("time-series-US-cost-1980-2025.csv")



ui1 <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput("decade", "Select a Decade:", choices = c("1980s" = 1980, "1990s" = 1990, "2000s" = 2000, "2010s" = 2010, "2020s" = 2020), selected = 1980),
      selectInput("disasters", "What disaster(s) would you like to include?", choices = c("Drought", "Flooding", "Freeze", "Severe Storm", "Tropical Cyclone", "Wildfire"), multiple = TRUE, selected = c("Drought", "Flooding", "Freeze", "Severe Storm", "Tropical Cyclone", "Wildfire"))
    ),
    mainPanel(
      plotOutput("heatmap")
    )
  )
)

server1 <- function(input, output, session){
  output$heatmap <- renderPlot({
    data1 <- frequency_billion
    data1 <- data1 %>% 
      rename(
        Drought = Drought.Count,
        Flooding = Flooding.Count,
        Freeze = Freeze.Count,
        `Severe Storm` = Severe.Storm.Count,
        `Tropical Cyclone` = Tropical.Cyclone.Count,
        Wildfire = Wildfire.Count
      )
    
    decade_start <- as.numeric(input$decade)
    decade_end <- ifelse(decade_start == 2020, 2024, decade_start + 9)
    decades = seq(decade_start, decade_end)
    filtered_data1 <- data1 %>% filter(Year %in% decades) %>%
      select(Year, all_of(input$disasters)) %>%
      pivot_longer(cols = all_of(input$disasters), names_to = "Disaster", values_to = "Frequency")
    
    
    title_text = paste("Frequency of U.S. Disasters With Damages \nExceeding $1BN (", decade_start, "-", decade_end, ")")
    
    ggplot(filtered_data1, aes(x = Year, y = Disaster, fill = Frequency)) +
      geom_tile(color = "white") +
      scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Frequency", limits = c(0,20)) +
      labs(title = title_text, x = "Year", y = "Disaster Type") + scale_x_continuous(breaks = decades, labels = as.character(decades))+ theme_minimal() + theme(
        plot.title = element_text(size = 20, face = "bold", hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        axis.text.y = element_text(size = 12),
        axis.title = element_text(size = 14),
        legend.title = element_text(size = 12)
      )
  })
}

shinyApp(ui1, server1)