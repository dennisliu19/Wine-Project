setwd("~/Desktop/Wine-Project")


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
