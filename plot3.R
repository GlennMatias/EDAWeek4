# Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) 
# variable, which of these four sources have seen 
# decreases in emissions from 1999-2008 for Baltimore City? 
# Which have seen increases in emissions from 1999-2008? 
# Use the ggplot2 plotting system to make a plot answer
# this question.

library(dplyr)
library(ggplot2)
require(gridExtra)

unzip(zipfile = "./exdata_data_NEI_data.zip")
# Load the datasets
nei = readRDS("summarySCC_PM25.rds")
scc = readRDS("Source_Classification_Code.rds")
# Perform occular inspection on the datasets if they have been imported correctly
View(nei)
View(scc)


# merge the two datasets
mergeDatasets = merge(x=nei,y=scc,by="SCC")

#Check if merge was successful
head(mergeDatasets)


#Get only the maryland data
baltimoreCityInMarylandSubset = subset(mergeDatasets,fips == "24510")

#Group the rows according to year
baltimoreCityInMarylandSubsetGroupedByYear = group_by(baltimoreCityInMarylandSubset,.dots = c("type","year"))

#summarise the data and create a row for its sum
output = summarise(baltimoreCityInMarylandSubsetGroupedByYear, sum = sum(Emissions))
View(output)

#Subset the first type
nonRoadSubset = subset(output, type=="NON-ROAD")
View(nonRoadSubset)

#Subset the second type
nonPointSubset = subset(output, type=="NONPOINT")
View(nonPointSubset)

#Subset the third type
onRoadSubset = subset(output, type=="ON-ROAD")
View(onRoadSubset)

#Subset the fourth type
pointSubset = subset(output, type=="POINT")
View(pointSubset)

#plot the first type
nonroad = ggplot(data=nonRoadSubset, aes(x=nonRoadSubset$year, y=nonRoadSubset$sum)) +
    geom_line()+
    geom_point() + xlab("year") + ylab(expression('Total Emissions')) + ggtitle("Non-road")

#plot the second type
nonpoint = ggplot(data=nonPointSubset, aes(x=nonPointSubset$year, y=nonPointSubset$sum)) +
    geom_line()+
    geom_point() + xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("Non-point")

onroad = ggplot(data=onRoadSubset, aes(x=onRoadSubset$year, y=onRoadSubset$sum)) +
    geom_line()+
    geom_point()+ xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("On-road")

point = ggplot(data=pointSubset, aes(x=pointSubset$year, y=pointSubset$sum)) +
    geom_line()+
    geom_point()+ xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("Point")




grid.arrange(nonroad, nonpoint, onroad, point, ncol=4)

