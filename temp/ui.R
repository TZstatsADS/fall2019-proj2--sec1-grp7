library(shiny)
library(shinythemes)
library(tidyverse)
library(leaflet)
library(DataExplorer)
library(funModeling)
library(Hmisc)

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
           
           tabPanel("Data", icon = icon("database"),
                    column(width = 3
                           ),
                    column(width = 9),
                    tags$div(id="cite",
                             'Data ', tags$em(''),
                             'Provided by Department of Sanitation (DSNY).'
                    ),
                    DT::dataTableOutput("gra_df")
                    ),
           
           
           ########3rd Panel##############
           
           tabPanel("About", icon = icon("info"),
                    # Application title
                    titlePanel("Resolution State"),
                    

                      
                      # Show a plot of the generated distribution
                      mainPanel(
                        plotOutput("ggplot1")
                      )
                    
                    
           ),
  
          tabPanel("Graffiti Frequencies",
           fluidRow(column(12,
                           h1("Graffiti Frequencies"),
                           p("The distribution of reported grafitti incidents vary by borough. There are more incidents in certain boroughs than other ones- this can be both due to the culture amongst different neighborhoods in the borough, but also can be due to other factors such as socioeconomic conditions. It is also important to note that just because there was a grafitti incident reported does not mean that there was actual grafitti. The third option, mapping, will show the different types of incidents that occured."),
                           br(),
                           h4("Types of charts"),
                           p("Select the buttons on the left to choose the type of chart to display. Resolution shows the different types of outcomes after reporting the grafitti incident. Borough shows the frequency of grafitti reports in the different boroughs. Resolution shows the different types of outcomes by color based on the latitude and longitude"))),
           hr(),
           fluidRow(sidebarPanel(width = 3,
                                 h4("Resolution Action vs Borough"),
                                 helpText("Chose whether you would like to see the frequency of graffiti in terms of borough, resolution, or mapping."),
                                 radioButtons("type", NULL,
                                              c("Resolution" = "Resolution",
                                                "Borough" = "Borough",
                                                "Mapping" = "Mapping"))),
                    mainPanel(plotOutput("freq", height = 500)))
            ),
           
           
           ########4th Panel##############
           
           navbarMenu("More",  icon = icon("caret-square-down"),
                      tabPanel("Summary"),
                      "----",
                      "Section header",
                      tabPanel("Table")
           )
)
