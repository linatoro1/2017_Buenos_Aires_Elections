library(rgdal)
library(leaflet)
library(dplyr)
library(htmltools)
library(tidyr)

logos <- c(
  "CAMBIEMOS BUENOS AIRES" = "https://upload.wikimedia.org/wikipedia/commons/6/65/Cambiemos_logo.png",
  "1PAIS" = "https://upload.wikimedia.org/wikipedia/commons/thumb/d/db/1_paislogo.png/1200px-1_paislogo.png",
  "UNIDAD CIUDADANA" = "https://upload.wikimedia.org/wikipedia/commons/thumb/1/11/Unidad_Ciudadana.svg/1200px-Unidad_Ciudadana.svg.png",
  "FRENTE DE IZQUIERDA Y DE LOS TRABAJADORES" = "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Frente_de_Izquierda_y_de_los_Trabajadores_Logo.svg/220px-Frente_de_Izquierda_y_de_los_Trabajadores_Logo.svg.png",
  "FRENTE JUSTICIALISTA" = "https://upload.wikimedia.org/wikipedia/en/thumb/e/ed/Logo_Justicialista.png/180px-Logo_Justicialista.png"
)

party_colors <- c(
  "CAMBIEMOS BUENOS AIRES" = "#ffff00",
  "1PAIS" = "#231476",
  "UNIDAD CIUDADANA" = "#52aaec",
  "FRENTE DE IZQUIERDA Y DE LOS TRABAJADORES" = "#ff1400",
  "FRENTE JUSTICIALISTA" = "#177034"
)

raw_first <- read.csv("all_tables_first_part.csv")
raw_middle <- read.csv("all_tables_reduced.csv")

raw_data <- rbind(raw_first, raw_middle)
levels(raw_data$section) <- gsub("[^\\-]*- ","",levels(raw_data$section))
levels(raw_data$section) <- gsub("Bol[^v]*var","Bolivar",levels(raw_data$section))

states <- readOGR(dsn = ".", layer = "partidos", GDAL1_integer64_policy = TRUE)
states <- spTransform(states, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))


aaa <- raw_data %>% filter(variable == "Senadores Nacionales") %>% group_by(section,partido) %>% summarise(suma=sum(value, na.rm = T))
bbb <- spread(aaa,key = partido,value = suma) 
bbb <- bbb[,c(1,(which(colSums(bbb[,setdiff(names(bbb),"section")]) > 1e5) +1 ))]
bbb[,2:ncol(bbb)] <- t(apply(bbb[,2:ncol(bbb)],1, function(x) round(x/sum(x,na.rm = T),2)))

bbb$max_color <- party_colors[ names(bbb)[2:ncol(bbb)][apply(bbb[,2:ncol(bbb)],1,which.max)] ]

total_amount <- raw_data %>% filter(variable == "Senadores Nacionales") %>% group_by(section) %>% summarise(total_votes=sum(value, na.rm = T))
# From https://www.census.gov/geo/maps-data/data/cbf/cbf_state.html
states <- readOGR(dsn = ".", layer = "partidos", GDAL1_integer64_policy = TRUE)
states <- spTransform(states, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Renombrara columnas para hacer merge
names(bbb)[1] <- "NOMBRE"
names(total_amount)[1] <- "NOMBRE"

# Merge de los datos
states@data <- left_join(states@data,bbb)
states@data <- left_join(states@data,total_amount)
states@data$tooltip <- createTooltips(states@data, names(logos))

leaflet(states) %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5,
              fillColor = ~max_color,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              label = ~lapply(tooltip, HTML))



library(treemap)
library(d3treeR)

# example 1 from ?treemap
d3tree3(
  treemap(
    states@data
    ,index=c("NOMBRE")
    ,vSize="total_votes"
    ,vColor="max_color"
    ,type="color"
    ,fontsize.labels = 0
    ,inflate.labels = TRUE
  )
  , rootname = "Section"
)
