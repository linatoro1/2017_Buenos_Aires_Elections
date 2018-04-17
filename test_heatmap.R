library(dplyr)
library(heatmaply)
library(tidyr)
library(reshape2)

raw_first <- read.csv("all_tables_first_part.csv")
raw_middle <- read.csv("all_tables_reduced.csv")

raw_data <- rbind(raw_first, raw_middle)
levels(raw_data$section) <- gsub("[^\\-]*- ","",levels(raw_data$section))
levels(raw_data$section) <- gsub("Bol[^v]*var","Bolivar",levels(raw_data$section))

raw_data <- subset(raw_data, partido %in% names(logos))

aaa <- raw_data  %>% filter(variable != "Concejales" & !grepl("Provinciales",variable)) %>% group_by(section,partido, variable) %>% summarise(suma=sum(value, na.rm = T))
aaa <- aaa %>% group_by(section,variable) %>% mutate(total_cargo = sum(suma, na.rm = T))
aaa$perc <- round(aaa$suma/aaa$total_cargo,2)
plot_data <- dcast(aaa,section ~ partido + variable, value.var = "perc")
rownames(plot_data) <- plot_data$section
plot_data$section <- NULL
plot_data[is.na(plot_data)] <- 0

heatmaply(plot_data)
