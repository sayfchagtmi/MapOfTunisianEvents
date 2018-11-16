library(leaflet)
library(shiny)

df = read.csv("1900-01-01-2018-11-09-Tunisia.csv",sep = ",")
map <- leaflet()
map <- addTiles(map)


ui <- fluidPage(

  titlePanel("Map of Tunisian's events"),
  sidebarLayout(
    sidebarPanel(
      selectInput("year",
                  "Select a year",
                  choices = c(unique(df$year))),
      htmlOutput("info")
    ),
    
    mainPanel(
      leafletOutput("map")
    )
  )
)

server <- function(input, output) {
  
  output$map <- renderLeaflet({
    
    df_year = df[which(df$year == strtoi(input$year)), ]
    for(i in 1:length(df_year$data_id)){
      long = df_year$longitude[i]
      lat = df_year$latitude[i]
      content = paste(sep = "<br/>",
                      paste("Event Type:",df_year$event_type[i],sep = " "),
                      paste("Event Date:",df_year$event_date[i],sep = " "),
                      paste("Source:",df_year$source[i],sep = " "),
                      paste("Notes:",df_year$notes[i],sep = " ")
      )
      map = addCircleMarkers(map, lng=long, lat=lat, popup=content , 
                              radius = (df_year$interaction[i])/5,
                              color = "#9E0142",
                              stroke = FALSE, fillOpacity = 0.5)
    }
    map
  })
  
  
  
  output$info = renderUI({
    
    Infos = paste(sep = "<br/> <br/>",
                  "<b>Data Source:</b>",
                  "<a href = 'https://www.acleddata.com/'>ACLED</a>",
                  "Political violence and protest includes events that occur within civil wars and periods of instability, public protest and regime breakdown."
                  )
    HTML(Infos)
  })
}

shinyApp(ui = ui, server = server)

