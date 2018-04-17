mapBuilder <- function(input,output,session, charge, map.type = c("multiple","individual")){
 
   output$map <- renderLeaflet({
     
     if(length(input$parties) == 0) return()
     
     sp_data <- enrichOGRObject(states,raw_data,charge(),input$parties)
     
     return(voteMap(sp_data, type = map.type, party_name = input$parties))
     
   })
  
}