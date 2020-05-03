##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Network - overlap of measures in time
## Script purpose: Calculate overlap matrix
## Date:12.04.2020.
## Authors: Elma Hot Dervic, Nils Haug, Amélie Desvars-Larrive
##################################################


library(dplyr)
library(stats)
library(mosaicData)
library(Matrix)
library(lattice)
library(mosaic)
library(rgexf)
library(stringr)

# ************************* LINKS *************************

all_dates <- unique(measures$Date)

Overlap <- matrix(0, ncol=numer_of_measures, nrow=numer_of_measures)
for(c in 1:length(countries_with_measures)) { 
  country_data_one_date <- measures %>% filter(Country == countries_with_measures[c])
  country_data_one_date <- country_data_one_date[, c(3:dim(measures)[2])]
   for(i in 1:numer_of_measures)
  {
    for(j in 1:numer_of_measures) {
      if(sum(country_data_one_date[,i])>0 & sum(country_data_one_date[,j])>0){
        # min date of measure i
        min_date_i <- min(which(country_data_one_date[,i]>0))
        # min date of measure j
        min_date_j <- min(which(country_data_one_date[,j]>0))
        if(min_date_i<=min_date_j){
          Overlap[i,j] <- Overlap[i,j]+(length(all_dates)-min_date_j)/(length(all_dates)-min_date_i)
        } else {
          Overlap[i,j] <- Overlap[i,j]+(length(all_dates)-min_date_i)/(length(all_dates)-min_date_i)
        }
      }
    }
  }
}


Overlap[is.na(Overlap)] <- 0
Overlap[is.nan(Overlap)] <- 0


Overlap[1,1]
Overlap[is.na(Overlap)] <- 0
Overlap[is.nan(Overlap)] <- 0
# max(Overlap)

# delete diag of matrix
for(i in 1:numer_of_measures){
  Overlap[i,i] <- 0
}

# saveRDS(Overlap,"Overlap.rds")
# write.csv(Overlap, "Overlap_matrix.csv")



# delete duplicated links
# always choose direction of first measure to second (later) measure
for(i in 1:numer_of_measures){
  for(j in i:numer_of_measures){
    if(Overlap[i,j]>=Overlap[j,i]){
      Overlap[i,j] <- 0
    } else  if(Overlap[i,j]<Overlap[j,i]){
      Overlap[j,i] <- 0
    }
  }
}


# # more often measures more overlap
# # devide by number of countries for each measure
for(i in 1:numer_of_measures){
  Overlap[i,] <- Overlap[i,]/nodes_size[i] 
}
# max(Overlap)



