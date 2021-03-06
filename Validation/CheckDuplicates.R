library(dplyr)

# Import static version of the data on governmental NPIs from Github
df <- read.csv("https://raw.githubusercontent.com/amel-github/CCCSL-Codes/master/COVID19_non-pharmaceutical-interventions_version2_utf8_static_2020-07-12.csv", colClasses=c("Country"="character"))

# For using live data
#df <- read.csv("https://raw.githubusercontent.com/amel-github/covid19-interventionmeasures/master/COVID19_non-pharmaceutical-interventions_version2_utf8.csv", colClasses=c("Country"="character"))


df %>% 
  group_by(iso3, Region, Date, Measure_L1, Measure_L2, Measure_L3, Measure_L4) %>% 
  filter(n()>1) %>% arrange(iso3, Date) -> reps

write.csv(reps, file="reps.csv", row.names = F)