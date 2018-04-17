enrichOGRObject <- function(ogr_object,additional_data,filter_variable, parties){
  
  aaa <- additional_data %>% filter(variable == filter_variable) %>% group_by(section,partido) %>% summarise(suma=sum(value, na.rm = T))
  bbb <- spread(aaa,key = partido,value = suma) 
  bbb[,2:ncol(bbb)] <- t(apply(bbb[,2:ncol(bbb), drop = FALSE],1, function(x) round(x/sum(x,na.rm = T),2)))
  bbb <- bbb %>% select(one_of(c("section",parties)))
  bbb$max_color <- party_colors[ names(bbb)[2:ncol(bbb)][apply(bbb[,2:ncol(bbb)],1,which.max)] ]
  total_amount <- raw_data %>% filter(variable == filter_variable) %>% group_by(section) %>% summarise(total_votes=sum(value, na.rm = T))
  
  # Renombrara columnas para hacer merge
  names(bbb)[1] <- "NOMBRE"
  names(total_amount)[1] <- "NOMBRE"
  
  # Merge de los datos
  ogr_object@data <- left_join(ogr_object@data,bbb)
  ogr_object@data <- left_join(ogr_object@data,total_amount)
  ogr_object@data$tooltip <- createTooltips(ogr_object@data, names(logos))
  
  return(ogr_object)
  
}
