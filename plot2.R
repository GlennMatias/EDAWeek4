# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering 
# this question.

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


#Get only the maryland data
baltimoreCityInMarylandSubset = subset(mergeDatasets,fips == "24510")

#Group the rows according to year
baltimoreCityInMarylandSubsetGroupedByYear = group_by(baltimoreCityInMarylandSubset,year)

#summarise the data and create a row for its sum
output = summarise(baltimoreCityInMarylandSubsetGroupedByYear, sum = sum(Emissions))
View(output)

#plot the data
barplot(main = 'Change in Emission in Baltimore City, Maryland', height=output$sum/1000, xlab="Year", ylab=expression('Total of Emissions'), names.arg=output$year)


