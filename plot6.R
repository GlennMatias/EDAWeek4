# Compare emissions from motor vehicle sources in
# Baltimore City with emissions from motor vehicle sources
# in Los Angeles County, California (fips == "06037").
# Which city has seen greater changes over time in motor vehicle emissions?
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

#Get only the los angeles data
losangelesInCaliforniaSubset = subset(mergeDatasets,fips == "06037")

#Group the rows according to year
losangelesInCaliforniaSubsetGroupedByYear = group_by(losangelesInCaliforniaSubset,.dots = c("type","year"))


#summarise the data and create a row for its sum
baltimoreOutput = summarise(baltimoreCityInMarylandSubsetGroupedByYear, sum = sum(Emissions))
View(baltimoreOutput)

#summarise the data and create a row for its sum
losAngelesOutput = summarise(losangelesInCaliforniaSubsetGroupedByYear, sum = sum(Emissions))
View(losAngelesOutput)

#Subset the road type
onRoadSubsetBaltimore = subset(baltimoreOutput, type=="ON-ROAD")
onRoadSubsetLosAngeles = subset(losAngelesOutput, type=="ON-ROAD")


#plot the plots
baltimorePlot = ggplot(data=onRoadSubsetBaltimore, aes(x=onRoadSubsetBaltimore$year, y=onRoadSubsetBaltimore$sum)) +
    geom_line()+
    geom_point()+ xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("Emissions from motor vehicle sources in Baltimore City")


losAngelesPlot = ggplot(data=onRoadSubsetLosAngeles, aes(x=onRoadSubsetLosAngeles$year, y=onRoadSubsetLosAngeles$sum)) +
    geom_line()+
    geom_point()+ xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("Emissions from motor vehicle sources in Los Angeles City")



