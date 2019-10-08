library(shiny)
library(shinythemes)
library(tidyverse)
library(leaflet)

function(input, output, session) {
  
  # gra_df <- read_csv("./data/DSNY_Graffiti_Tracking.csv")
  # save(gra_df, file = "DSNY_Graffiti_Tracking.RData")
  load("DSNY_Graffiti_Tracking.RData")
  gra_df = gra_df %>% 
    janitor::clean_names() %>% 
  filter(!is.na(latitude) &  !is.na(longitude)) 
  
  borough_df <- reactive({
    gra_df %>% filter(borough == input$borough)
  })
  
  gra_df %>% group_by(resolution_action) %>% count()
  
  output$map1 <- renderLeaflet({
    leaflet(borough_df()) %>% 
      #setView(lng = -99, lat = 45, zoom = 2)  %>% #setting the view over ~ center of North America
      addTiles() %>% 
      addCircles(data = borough_df(), lat = ~ latitude, lng = ~ longitude, weight = 1,
                 popup = ~incident_address, 
                 label = ~status, fillOpacity = 0.5)
  })
  
  output$gra_df <- DT::renderDataTable({
    action <- DT::dataTableAjax(session, gra_df)
    
    DT::datatable(gra_df, options = list(ajax = list(url = action)), escape = FALSE)
  })
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
  
  output$ggplot1 <- renderPlot({
    ggplot(data = gra_df) +
      geom_point(mapping = aes(x = longitude, y = latitude, color = resolution_action))
  })
  
  output$freq <- renderPlot({
    if ( input$type == "Mapping" ) {
      ggplot(data = gra_df) +
        geom_point(mapping = aes(x = longitude, y = latitude, color = resolution_action))
    } else if ( input$type == "Resolution") {
      freq(gra_df$resolution_action)
    } else if ( input$type == "Borough") {
      freq(gra_df$borough)
    }
  })
}