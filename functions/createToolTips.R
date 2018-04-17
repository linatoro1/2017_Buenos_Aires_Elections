createTooltips <- function(x,parties){
  
  opening_div <- "<div style='font-size:12px;width:200px'>"
  titles <- createToolTipTitles(x$NOMBRE)
  sub_div <- "<div style='width:95%%'>"
  bars <- createTooltipBars(x,parties)
  close_subdiv <- "</div><br/>"
  total_footnote <- createToolTipFootNotes(x$total_votes)
  close_tooltip <- "</div"
  
  ret <- paste0(opening_div,titles,sub_div,bars,close_subdiv,total_footnote,close_tooltip)
  return(ret)
  
  
}