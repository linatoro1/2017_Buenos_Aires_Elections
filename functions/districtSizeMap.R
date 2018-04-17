districtSizeMap <- function(data_object, type = c("multiple","individual"), party_name = NULL){
 
  type <- match.arg(type)
  
  treemap_type <- switch(type,
                     "multiple" = "color",
                     "individual" = "value")
  
  color_var <- switch(type,
                      "multiple" = "max_color",
                      "individual" = party_name)
  
    
  color_scale <- switch(type,
                    "individual" = colorRampPalette(colors=c("#FFFFFF", party_colors[party_name]))(7),
                    "multiple" = "RdYlGn")
  
  
  d3tree3(
    treemap(
      data_object
      ,index=c("NOMBRE")
      ,vSize="total_votes"
      ,vColor=color_var
      ,type=treemap_type
      ,palette = color_scale
      ,fontsize.labels = 0
      ,inflate.labels = TRUE
      ,range = c(0,0.7)
      ,mapping=c(0, 0.35, 0.7)
    )
    , rootname = "Section"
  )
  
   
}