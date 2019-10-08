library(shiny)
library(shinythemes)
library(tidyverse)
library(leaflet)

navbarPage( windowTitle = "NYC Graffiti",
            title = div(img(src="NYC.jpg",height = 30,
                            width = 50), "Graffiti"), 
            id="gra", theme = shinytheme("journal"), #themeSelector(),
            
            ########1st Panel##############
            
            tabPanel("Map", icon = icon("map-signs"),
                     tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                     div(class = "outer",
                         
                         tags$head(
                           # Include our custom CSS
                           includeCSS("styles.css"),
                           includeScript("gomap.js")
                         ),
                         
                         leafletOutput("map1", width = "100%", height = "100%"),
                         
                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                       draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                       width = 330, height = "auto",
                                       
                                       h3("Flowing Panel"),
                                       selectInput("borough", "Borough", 
                                                   choices = list("MANHATTAN", "BROOKLYN","BRONX","QUEENS",
                                                                  "STATEN ISLAND"),
                                                   selected = "MANHATTAN")
                         )
                         
                     )
            ),
            
            ########2nd Panel##############
            
            tabPanel("Heat Map", icon = icon("map-signs"),
                     tags$style(".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"),
                     div(class = "outer",
                         
                         tags$head(
                           # Include our custom CSS
                           includeCSS("styles.css"),
                           includeScript("gomap.js")
                         ),
                         
                         leafletOutput("map2", width = "100%", height = "100%"),
                         
                         absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                       draggable = TRUE, top = 150, left = 0, right = 40, bottom = "auto",
                                       width = 400, height = "auto",
                                       br(),
                                       radioButtons("selectb", label = "Layers",
                                                    choices = list("Count" = "count", "Close Rate" = "close_rate"), 
                                                    selected = "count"),
                                       
                                       plotOutput("month_trend", height = 280)
                                       #plotOutput("police_plot", height = 280)
                                       
                         )
                     )
                     
            ),
            
            
            ########3rd Panel##############
            
            tabPanel("About", icon = icon("info"),
                     fluidRow(),
                     fluidRow(),
                     hr()
            ),
            
            
            ########4th Panel##############
            
            navbarMenu("More",  icon = icon("caret-square-down"),
                       tabPanel("Summary"),
                       "----",
                       "Section header",
                       tabPanel("Table")
            )
)
