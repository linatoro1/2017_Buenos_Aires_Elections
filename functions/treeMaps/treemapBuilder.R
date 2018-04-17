treemapBuilder <- function(input,output,session, charge, map.type = c("multiple","individual")){
 
   output$treemap <- renderD3tree3({
     
     if(length(input$parties) == 0) return()
     
     sp_data <- enrichOGRObject(states,raw_data,charge(),input$parties)
     
     return(districtSizeMap(sp_data@data, type = map.type, party_name = input$parties))
     
   })
  
}