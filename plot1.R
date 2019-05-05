# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
#Using the base plotting system, make a plot showing the total PM2.5 
#emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#Load packages
library(dplyr)

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

neiGroupedByYear = group_by(nei,year)
output = summarise(neiGroupedByYear, sum = sum(Emissions))

View(output)
barplot(main = 'Change in Emission', height=output$sum/1000, xlab="Year", ylab=expression('Total of Emissions'), names.arg=output$year)

