heatmapBuilder <- function(input,output,session){
 
   output$heatmap <- renderPlotly({
     
     input$run
     
     isolate({
       
       if(input$run == 0) return()
       
       if(input$charges == "All") selected_charges <- levels(raw_data$variable) else selected_charges <- input$charges
       if(input$parties == "All") selected_parties <- levels(raw_data$partido) else selected_parties <- input$parties
       if(input$sections == "All") selected_sections <- levels(raw_data$section) else selected_sections <- input$sections
       
       aaa <- raw_data  %>% filter(variable %in% selected_charges & partido %in% selected_parties & section %in% selected_sections) %>% group_by(section,partido, variable) %>% summarise(suma=sum(value, na.rm = T))
       aaa <- aaa %>% group_by(section,variable) %>% mutate(total_cargo = sum(suma, na.rm = T))
       aaa$perc <- round(aaa$suma/aaa$total_cargo,2)
       plot_data <- dcast(aaa,section ~ partido + variable, value.var = "perc")
       rownames(plot_data) <- plot_data$section
       plot_data$section <- NULL
       plot_data[is.na(plot_data)] <- 0
       
       ret <- heatmaply(plot_data)
       
       return(ret)
       
     })
     
   })
   
   for(i in c("charges","parties","sections")){
     
     expr = substitute({
       observeEvent(input[[input_var]],{
         if("All" %in% input[[input_var]]) updateSelectInput(session, input_var, selected = "All")
       })
       },list(input_var = i))
    
     eval(expr)
     
   }
  
}