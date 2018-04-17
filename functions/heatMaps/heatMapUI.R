drawHeatmapUI <- function(namespace_name){
  
  namesp <- NS(namespace_name)
  
  box(width = 12,
    
    fluidRow(
      column(4, selectInput(namesp("sections"), "Select sections", choices = c(levels(raw_data$section),"All"), 
                            selected = "All", multiple = T)),
      column(4, selectInput(namesp("charges"), "Select charges", choices = c(levels(raw_data$variable),"All"), 
                            selected = "All", multiple = T)),
      column(4, selectInput(namesp("parties"), "Select parties", choices = c(levels(raw_data$partido),"All"), 
                            selected = "All", multiple = T))
    ),
    fluidRow(
      column(2, offset = 9, actionButton(namesp("run"),"Run Heatmap"))
    ),
    
    div(style="margin-top:50px",plotlyOutput(namesp("heatmap"), height = "600px"))
    
  )
  
}