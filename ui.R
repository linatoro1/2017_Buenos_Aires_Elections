
library(shiny)

dashboardPage(
  dashboardHeader(title = "2017 Elections in Buenos Aires Province"),
  dashboardSidebar( sidebarMenu(
    menuItem("Overview", tabName = "overview", icon = icon("globe")),
    menuItem("Analysis", tabName = "analysis", icon = icon("bar-chart"))
  )),
  dashboardBody(
    tabItems(
      tabItem("overview",
              fluidRow(
                column(6,selectInput("charge", "Select charge to visualize", levels(raw_data$variable))
                       )),
              fluidRow(
                column(6, h3("Overview"))
              ),  
              fluidRow(
                  column(6,drawMapUI("map1")
                         ),
                  column(6,drawTreeMapUI("treemap1")
                        )
                ),
              fluidRow(
                column(6, h3("Comparison"))
                       ),
              fluidRow(
                column(6, selectInput("comparison_plot", "Select Comparison Plot", choices = c("Map", "Treemap")))
              ),
              #Aca va a ir un selector para comparar por treemap o por mapa
              conditionalPanel("input.comparison_plot == 'Map'",
              fluidRow(
                  column(6,drawMapUI("map_compare1",is.multiple = F)),
                  column(6,drawMapUI("map_compare2",is.multiple = F))
                  )
              ),
              conditionalPanel("input.comparison_plot == 'Treemap'",
                               fluidRow(
                                 column(6,drawTreeMapUI("treemap_compare1",is.multiple = F)),
                                 column(6,drawTreeMapUI("treemap_compare2",is.multiple = F))
                               )
              )
      ),
      tabItem("analysis",
              drawHeatmapUI("heatmap"))
    )
  )
)
