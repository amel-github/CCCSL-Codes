# Generate the Master List of Codes

# Import static version of the data on governmental NPIs from Github
df <- read.csv("https://raw.githubusercontent.com/amel-github/CCCSL-Codes/master/COVID19_non-pharmaceutical-interventions_version2_utf8_static_2020-07-12.csv", colClasses=c("Country"="character"))

# For using live data
#df <- read.csv("https://raw.githubusercontent.com/amel-github/covid19-interventionmeasures/master/COVID19_non-pharmaceutical-interventions_version2_utf8.csv", colClasses=c("Country"="character"))

## Generate file of unique combination of theme (L1)/category (L2)/subcategory (L3)/code (L4)
unique.combi <- unique(df[,c("Measure_L1","Measure_L2","Measure_L3", "Measure_L4")])
# create the csv file
write.csv (unique.combi, file = "Master_list_CCCSL_v2.csv")

## Order the list alphabetically
ordered <- unique.combi[
  with(unique.combi, order(Measure_L1, Measure_L2, Measure_L3, Measure_L4)),
  ]
# create the csv file
write.csv (ordered, file = "Master_list_CCCSL_v2_ordered.csv", row.names = FALSE)


#### Master List showing hierarchical relationship and number of occurrence of each pair of parent/child codes
df_L1L2 <- df%>% group_by(Measure_L1, Measure_L2) %>% tally
df_L1L2$link <- rep("L1-L2", nrow(df_L1L2 ))
colnames(df_L1L2) <- c("parent", "child", "value","link")

df_L2L3 <- df %>% group_by(Measure_L2, Measure_L3) %>% tally
df_L2L3$link <- rep("L2-L3", nrow(df_L2L3))
colnames(df_L2L3) <- c("parent", "child", "value","link")

df_L3L4 <- df %>% group_by(Measure_L3, Measure_L4) %>% tally
df_L3L4$link <- rep("L3-L4", nrow(df_L3L4))
colnames(df_L3L4) <- c("parent", "child", "value","link")

table <- rbind.data.frame(df_L1L2,df_L2L3,df_L3L4 )

table.with.links <- table[, c(1,4, 2,3)]

# create the csv file
write.csv(table.with.links, file ="Master-List-with-Unique-LinkType-and-value.csv",row.names=FALSE)   