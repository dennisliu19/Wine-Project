setwd("~/Desktop/Wine-Project/Dataset and Script")
library("dplyr")
if("manipulate" %in% installed.packages())(install.packages("manipulate"))
if("mosaic" %in% installed.packages())(install.packages("mosaic"))
if("ggpubr" %in% install.packages())(install.packages("ggpubr"))

library(manipulate)
library(mosaic)
library(ggpubr)
winedata <- read.csv("winemag-data_first150k.csv")


countrysummary <- winedata %>% 
  group_by(country) %>%
  summarise(no_rows = length(X))

countrylist <- c("US","Spain","Italy","France","Argentina","Portugal","Chile","Australia")

wineupdate <- filter(winedata, winedata$country %in% countrylist)
varietysummary <- wineupdate %>% 
  group_by(variety) %>%
  summarise(no_rows = length(X))
varietysummary <- varietysummary[order(-varietysummary$no_rows),]
varietyselection <- varietysummary$variety[1:8]
wineupdate <- filter(wineupdate, wineupdate$variety %in% varietyselection)
wineupdate <- mutate(wineupdate, category = ifelse(variety %in% c("Chardonnay","Sauvignon Blanc"),"white","red" ))
wineupdate <- mutate(wineupdate, countrycat = ifelse(country %in% c("US","Argentina","Chile","Australia"),"non-eu","eu"))                  

 ggboxplot(wineupdate, x = "category", y = "points", color = "countrycat",
           palette = c("#00AFBB", "#E7B800"))
interaction.plot(wineupdate$category,wineupdate$countrycat,wineupdate$points)

winetruc <- wineupdate[,c(2,5,6,10,12,13)]

winetruc$country <- factor(winetruc$country)

ggboxplot()
