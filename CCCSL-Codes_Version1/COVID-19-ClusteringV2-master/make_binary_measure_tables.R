##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Clustering of countries based on implemented measures
## Script purpose: This script creates binary representations of the CCCSL data set on category level (L2)
## Date:12.04.2020.
## Authors: Elma Hot Dervic, Nils Haug, Amélie Desvars-Larrive
##################################################

# Downloads the CCCSL data set on implemented non-pharmaceutical interventions (NPI) and writes the two csv files "bin_COVID19_measures.csv" 
# and "bin_COVID19_measures_cumulative.csv" into the current directory. Both files contain a column "Country" and a column "Date", as well 
# as one column for each NPI category (L2). The columns coresponding to NPI categories contain boolean values. In a given row and a given
# column of "bin_COVID19_measures.csv" corresponding to a given NPI M, the value TRUE indicates that on the given date, M was put in place
# in the given country. Otherwise, the entry is FALSE. Similarly, in a given row and a given column of "bin_COVID19_measures_cumulative.csv"
# corresponding to a given NPI M, the value TRUE indicates that on or before the given date, M was put in place in the given country. 
# Otherwise, the entry is FALSE.

library(readr)

# Define url for accessing data

measurelist_url = 'https://raw.githubusercontent.com/amel-github/CCCSL-Codes/master/COVID19_non-pharmaceutical-interventions_version2_utf8_static_2020-07-12.csv'

# Import data on intervention measures

measure_df <- read_csv(measurelist_url)
measure_df['Date'] <- lapply(measure_df['Date'],function(x) as.Date(x,'%d/%m/%Y'))

measure_df['Date_numeric'] <- lapply(measure_df['Date'],function(x) as.numeric(x))

# Create table of NPI categories (L2) and give unique ID to each category

measurelist <- measure_df[,c("Measure_L1","Measure_L2")]
measurelist <- measurelist[!duplicated(measurelist),]
measurelist["Measure"] <- paste("L1: ",measurelist$Measure_L1," / L2: ",measurelist$Measure_L2)
measurelist <- measurelist[order(measurelist$Measure),]
measurelist['Measure_id'] <- c(1:dim(measurelist)[1])

# Join measure_df with measurelist to get ID of each measure

measure_df <- merge(measure_df,measurelist,by=c("Measure_L1","Measure_L2"))

# Define date range to be covered by the output files

day0 <- as.Date("2019/12/1",'%Y/%m/%d') 
mindate <- as.numeric(day0) # day from which to start registering measures
maxdate <- as.numeric(Sys.Date())-1 # day until which measures are recorded

# Get list of all countries appearing in the data set

countries <- unique(measure_df[["Country"]])
countries <- countries[order(countries)]

# Initialise data frames for binary measure data

bindata = data.frame()
bindata_cumulative = data.frame()

for (country in countries) {
  
  countrymeasures <- measure_df[measure_df$Country==country,][c('Date_numeric','Measure_id')]

  binmatrix <- matrix(FALSE,maxdate-mindate+1,dim(measurelist)[1])
  binmatrix_cumulative <- matrix(FALSE,maxdate-mindate+1,dim(measurelist)[1])

  i <- 1

  for (day in c(mindate:maxdate))
    
    {
    # loop over days from mindate until maxdate
  
    newmeasures <- unlist(countrymeasures[countrymeasures$Date_numeric==day,]$Measure_id)
    previousmeasures <- unlist(countrymeasures[countrymeasures$Date_numeric<day,]$Measure_id)
    binmatrix[i,newmeasures] <- TRUE
    binmatrix_cumulative[i,newmeasures] <- TRUE
    binmatrix_cumulative[i,previousmeasures] <- TRUE      

    i <- i+1
    
  }

  # binary encoding of measures taken in country

  bindata_country <- as.data.frame(binmatrix)
  bindata_country['Country'] <- country
  bindata_country['Date'] <- list(mindate:maxdate)
  
  bindata_country_cumulative <- as.data.frame(binmatrix_cumulative)
  bindata_country_cumulative['Country'] <- country
  bindata_country_cumulative['Date'] <- list(mindate:maxdate)

  # append to big table containing binary data on all countries

  bindata <- rbind(bindata,bindata_country)
  bindata_cumulative <- rbind(bindata_cumulative,bindata_country_cumulative)

}

names(bindata) <- append(measurelist$Measure,list('Country','Date'))
names(bindata_cumulative) <- append(measurelist$Measure,list('Country','Date'))

bindata['Date'] <- lapply(bindata['Date'],function(x) as.Date(x,origin='1970-1-1'))
bindata_cumulative['Date'] <- lapply(bindata_cumulative['Date'],function(x) as.Date(x,origin='1970-1-1'))

bindata <- bindata[unlist(append(list('Country','Date'),measurelist$Measure))]
bindata_cumulative <- bindata_cumulative[unlist(append(list('Country','Date'),measurelist$Measure))]

##### Export to csv

write.csv2(bindata,'bin_COVID19_measures.csv',row.names=FALSE)
write.csv2(bindata_cumulative,'bin_COVID19_measures_cumulative.csv',row.names=FALSE)
