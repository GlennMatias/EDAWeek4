# Across the United States, how have emissions from coal 
# combustion-related sources changed from 1999-2008?

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


#Subset the rows with coal in the EI column
coalSubset <- mergeDatasets[grep("[Cc]oal",mergeDatasets$EI.Sector),]


coalSubsetgroupedBy = group_by(coalSubset, year)

output = summarise(coalSubsetgroupedBy, sum = sum(Emissions))
View(output)

#plot the plot
ggplot(data=output, aes(x=output$year, y=output$sum)) +
    geom_line()+
    geom_point() + xlab("year") +  
    ylab(expression('Total Emissions')) + ggtitle("Coal combustion-related Emissions across the US")
