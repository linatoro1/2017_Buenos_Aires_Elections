createTooltipBar <- function(img_src, bar_color,value_vector){
  sprintf("<br/>
          <img style='width: 40px; object-fit: contain; float:left; display:inline-block;' src= '%s'/>
          <div style='left:55px; width:150px'>
            <span style='background:%s;width:%s%%; float:left'>&nbsp;</span>
            <span style='color:%s';float:right>%s%%</span>
          </div>",
          img_src,
          bar_color,
          value_vector * 100,
          bar_color,
          value_vector * 100
          )
}

createTooltipBars <- function(plot_data,vars){
  
  all_bars <- lapply(vars, function(x) createTooltipBar(logos[x], party_colors[x], plot_data[[x]]))
  
  ret <- ""
  for(i in all_bars) ret <- paste(ret,i, sep = "")
  return(ret)
  
}