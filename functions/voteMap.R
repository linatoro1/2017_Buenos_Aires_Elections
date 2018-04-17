voteMap <- function(ogr_object, type = c("multiple","individual"), party_name = NULL){
  
  type <- match.arg(type)
  
  fill_var <- switch(type,
                     "multiple" = "max_color",
                     "individual" = "party_intensity")
  
  if(type == "individual"){
   
    palette <- colorRampPalette(colors=c("#FFFFFF", party_colors[party_name]))
    cols <- palette(5)
    
    ogr_object@data$party_intensity <- cols[findInterval(ogr_object@data[[party_name]], seq(0,0.7,length.out = 6))]
    
  }
  
  ret <- leaflet(ogr_object) %>%
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
                opacity = 1.0, fillOpacity = 0.5,
                fillColor = ~get(fill_var),
                highlightOptions = highlightOptions(color = "white", weight = 2,
                                                    bringToFront = TRUE),
                label = ~lapply(tooltip, HTML))
  
  return(ret)
  
}