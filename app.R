library(dygraphs)
library(tidyverse)
library(magrittr)
library(dplyr)
library(xts)
load("D:/Duke/Work(Environ)/Data/public_data.Rdata")

#reformat table using dplyr to have sites in columns (long data table)
gather(hydro.annual, hydroVars, value, P:ET, na.rm = F, convert = T)

#make hydro.annual$water.year a character to add month and day on
hydro.annual$water.year <- as.character(hydro.annual$water.year)

#reformat water year into an 'appropriate time-based object'
hydro.annual['water.year'] <- apply(hydro.annual[,'water.year', drop = F], 2, 
                                    function(x){paste0(x, '/07/01')})

as.Date(hydro.annual$water.year)
#ws1 = rows 1-60, ws2 = rows 61-120, ws3 = 121-180, 
#ws4 = 181-240?, ws5 = 241-300?, ws6 = 301-360?

#use xts to do magic
#plug into the dygraph of discharge (Q) and pretty-fy
xts(hydro.annual$Q[c(301:360), drop = F], 
    order.by = as.POSIXct(hydro.annual$water.year[c(301:360),, drop = F], 
                                                   origin = "1955/07/01")) %>%
  dygraph(., main = "W6", xlab = "Water Year", ylab = "Annual Water Flux (mm/yr)") %>%
   dyAxis("x", drawGrid = F) %>%
   dyOptions(includeZero = T,
             connectSeparatedPoints = T,
             colors = "blue",
             drawPoints = T, pointSize = 5,
             gridLineColor = "white")
#add graph of precipitation (P) to discharge graph




