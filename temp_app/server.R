library(shiny)
library(shinythemes)
library(tidyverse)
library(leaflet)
library(lubridate)
library(scales)
library(sf)
library(tigris)
library(nycgeo)

function(input, output, session) {
  
  #cleaned_NYPD_df <- read_csv("./output/cleaned_NYPD_Arrests.csv")
  #save(cleaned_NYPD_df, file = "./app/cleaned_NYPD_Arrests.Rdata")
  #load("./app/DSNY_Graffiti_Tracking.RData")
  #load("./temp_app/DSNY_Graffiti_Tracking.RData")
  load("DSNY_Graffiti_Tracking.RData")
  load("cleaned_NYPD_Arrests.Rdata")

  
  gra_df = gra_df %>% 
    janitor::clean_names() %>% 
  filter(!is.na(latitude) &  !is.na(longitude) & !is.na(city_council_district)) 
  
  nhyc_cd_data <- cd_sf

    gra_df = gra_df %>% 
    janitor::clean_names() %>% 
    filter(!is.na(latitude) &  !is.na(longitude) & !is.na(city_council_district)) %>%
    mutate(cd_id = str_extract(community_board, "[[:digit:]]+"),
           borough_id = case_when(
             borough == "MANHATTAN" ~ "1",
             borough == "BRONX" ~ "2",
             borough == "BROOKLYN" ~ "3",
             borough == "QUEENS" ~ "4",
             borough == "STATEN ISLAND" ~ "5"),
           borough_cd_id = str_c(borough_id, cd_id))
  
  temp_df =  gra_df %>% 
    filter(status == "Closed") %>% 
    group_by(borough_cd_id, status) %>% 
    summarise(close_count = n()) %>%
    left_join(gra_df %>% 
                group_by(borough_cd_id) %>% 
                summarise(ttl_count = n()), by = "borough_cd_id") %>%  
    mutate(close_rate = close_count/ttl_count) %>%
    ungroup() 
  
  map_data <- geo_join(nhyc_cd_data, temp_df, "borough_cd_id",  "borough_cd_id", how = "inner") %>% 
    mutate(ttl_count = as.numeric(ttl_count), close_rate = as.numeric(close_rate))

  min(map_data$close_rate)
  
  #############1007###############
  # install.packages("remotes")
  # remotes::install_github("mfherman/nycgeo")
  
  output$map2 <- renderLeaflet({
    
    if(input$selectb == "count"){
      bins <- c(0, 200, 400, 600, 800, 1000, 1400, 1800)
      pal <- colorBin("Reds", domain = map_data$ttl_count, bins = bins)
      popup1 = paste0('<strong>Count: </strong><br>', map_data$ttl_count,
                      '<br><strong>Close Rate: </strong><br>', round(map_data$close_rate,2),
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup1,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal(ttl_count),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal, values = ~bins, opacity = 0.6, title = "Number of Complaints",
                  position = "bottomright")
    } else{
      bins2 <- c(0.3, 0.5, 0.7, 0.9, 1)
      pal2 <- colorBin("Blues", domain = map_data$close_rate, bins = bins2)
      popup2 = paste0('<strong>Count: </strong><br>', map_data$ttl_count,
        '<br><strong>Close Rate: </strong><br>', round(map_data$close_rate,2), 
                      '<br><strong>Name: </strong><br>', map_data$cd_name)
      
      map_data %>%
        st_transform(., "+init=epsg:4326") %>%
        leaflet() %>%
        addTiles() %>%
        addPolygons(popup = popup2,
                    layerId=~borough_cd_id,
                    #label = ~ttl_count,
                    fillColor = ~pal2(close_rate),
                    color = 'grey', 
                    fillOpacity = .6,
                    weight = 1,
                    dashArray = "3") %>% 
        addProviderTiles("CartoDB.Positron") %>% 
        addLegend(pal = pal2, values = ~bins2, opacity = 0.6, title = "Close rate",
                  position = "bottomright")
    }
  })
  
  

  
  observe({
    #whenever map item is clicked, becomes event
    event <- input$map2_shape_click
    if (is.null(event))
      return()

    output$month_trend <- renderPlot({
      #returns null if no borough selected
      if (is.na(event$id)) {
        return(NULL)
      }

      gra_df %>% mutate(shown_date = format.Date(as.Date(created_date, format = "%m/%d/%Y"), "%b %y"),
                        sort_date = format(as.Date(created_date, format = "%m/%d/%Y"), "%Y%m")) %>%
        mutate(cd_id = as.character(as.numeric(str_extract(city_council_district, "[[:digit:]]+")))) %>%
        filter(borough_cd_id == event$id) %>%
        group_by(shown_date, sort_date) %>%
        summarize(ttl = n()) %>%
        ungroup() %>%
        arrange(sort_date) %>%
        mutate(shown_date = factor(shown_date, levels = shown_date)) %>%
        ggplot(aes(x=shown_date, y = ttl)) +
        geom_bar(stat="identity", na.rm = TRUE, color="lightblue", fill = "lightblue") +
        theme_bw() +
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
        labs(x = "Month", y = "Number of complaints", title = "Number of complaints monthly trend")

    })
    
    output$police_plot <- renderPlot({
      ggplot(data=cleaned_NYPD_df,aes(x=ARREST_DATE,y=Count)) +
          geom_bar(stat = "identity",color = "lightgreen",fill="lightgreen") +
            theme_bw() +
            theme(axis.text.x = element_text(angle = 90,hjust = 1)) +
            labs(x="Month",y="Number of Arrests",title = "Arrests by Month")
     })
    
  })
}
