drawTreeMapUI <- function(namespace_name, is.multiple = T){
  
  namesp <- NS(namespace_name)
  
  if(is.multiple) default_selected <- names(logos) else default_selected <- names(logos)[1]
  
  box(width = 12,
    
    selectInput(namesp("parties"), "Select party", choices = names(logos), multiple = is.multiple, selected = default_selected),
    d3tree3Output(namesp("treemap"))
    
  )
  
}