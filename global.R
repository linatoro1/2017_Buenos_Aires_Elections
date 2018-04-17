library(heatmaply)
library(shiny)
library(treemap)
library(d3treeR)
library(rgdal)
library(leaflet)
library(dplyr)
library(htmltools)
library(tidyr)
library(shinydashboard)
library(plotly)
library(reshape2)

for(i in list.files("functions", recursive = T)) source(paste("functions",i, sep = "/"))

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
raw_data <- subset(raw_data, partido %in% names(logos))

raw_data <- droplevels(raw_data)

states <- readOGR(dsn = ".", layer = "partidos", GDAL1_integer64_policy = TRUE)
states <- spTransform(states, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

