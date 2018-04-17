
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  callModule(mapBuilder,"map1",reactive(input$charge))
  callModule(treemapBuilder,"treemap1",reactive(input$charge))
  callModule(mapBuilder,"map_compare1",reactive(input$charge), map.type = "individual")
  callModule(mapBuilder,"map_compare2",reactive(input$charge), map.type = "individual")
  callModule(treemapBuilder,"treemap_compare1",reactive(input$charge), map.type = "individual")
  callModule(treemapBuilder,"treemap_compare2",reactive(input$charge), map.type = "individual")
  callModule(heatmapBuilder,"heatmap")
})
