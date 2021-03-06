##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Visualise the aggressiveness (number of NPIs) and responsiveness (timeline) of the government control strategies
## Script purpose: K-means clustering to cluster countries based on the timeline of the implemented measures
## Date:12.07.2020.
## Authors: Elma Hot Dervic, Nils Haug, Amélie Desvars-Larrive
##################################################

library(tidyverse)
library(plotly)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(cluster) 
library(plot3D)
library(countrycode)

first_date_matrix <- matrix(NA, nrow=length(countries_with_measures), ncol=(ncol(measures)-2))
min_date_10_cases <- rep(0, length(countries_with_measures))
min_date_first_death <- rep(0, length(countries_with_measures))
min_date_200_cases <- rep(NA, length(countries_with_measures))

for(i in 1:length(countries_with_measures)) {
  country.name <- countries_with_measures[i]
  onecountry_measures <- measures[measures$Country==country.name, ]
  JH_data_one_country <-  JH_data %>% filter(country == country.name)
  date_cases <- JH_data_one_country$date[JH_data_one_country$cases>=10]
  min_date_first_death[i] <- min(JH_data_one_country$date[JH_data_one_country$deaths>0])
  date_cases_200 <- JH_data_one_country$date[JH_data_one_country$cases>=200]
   if(length(date_cases)!=0){
    min_date_10_cases[i] <- min(date_cases) 
    if(length(date_cases_200)!=0){
    min_date_200_cases[i] <- min(date_cases_200 ) }
    if(nrow(JH_data_one_country)>2 & nrow(onecountry_measures)>0){
      for(j in 3:dim(measures)[2]){
        if(sum(onecountry_measures[,j])>0){
          min_date <- min(onecountry_measures$Date[onecountry_measures[,j]])
          if(!is.na(min_date) & !is.na(min_date_10_cases[i])){i
            min_date <- as.Date(min_date)
            first_date_matrix[i,(j-2)] <- as.numeric(min_date - min_date_10_cases[i])
          } }
      } } } } 

# min_date_first_death 
min_date_first_death <- as.Date( min_date_first_death, origin = "1970-01-01")

# min_date_10_cases
min_date_10_cases <- as.Date( min_date_10_cases, origin = "1970-01-01")

# min_date_200_cases
min_date_200_cases <- as.Date( min_date_200_cases, origin = "1970-01-01")
# "Liechtenstein" "Syria" do not have 200 cases still -- 
# countries_with_measures[is.na(min_date_200_cases)]
min_date_200_cases[is.na(min_date_200_cases)] <- "2020-05-01"
min_date_200_cases

time_window_10_to_200_cases <- as.numeric(min_date_200_cases-min_date_10_cases)

# filter only choosen measures
treshold_num_coutries <- 15
selected_measures <- "Risk communication"  
choosen_measures <- str_detect(names(measures), selected_measures)[3:dim(measures)[2]]
first_date_matrix_filtered <- first_date_matrix[,-which(choosen_measures)]

selected_measures <- "Returning to normal life" 
choosen_measures <- str_detect(names(measures), selected_measures)[3:dim(measures)[2]]
first_date_matrix_filtered <- first_date_matrix[,-which(choosen_measures)]

measures_size <- colSums(!is.na(first_date_matrix_filtered))
first_date_matrix_filtered <- first_date_matrix_filtered[,which(measures_size>=treshold_num_coutries )]

# names of selected measures
filtered_names_l2 <- names_l2[-which(choosen_measures)]
filtered_names_l2 <- filtered_names_l2[which(measures_size>=treshold_num_coutries )]

first_date_matrix_filtered_scaled <- first_date_matrix_filtered
first_date_matrix_filtered_scaled[!is.na(first_date_matrix_filtered) & first_date_matrix_filtered < 0  ] <- 0

for(i in 1:length(countries_with_measures))
{
  first_date_matrix_filtered_scaled[i,!is.na(first_date_matrix_filtered[i,]) & first_date_matrix_filtered[i,] >=0 &  first_date_matrix_filtered[i,] < time_window_10_to_200_cases[i]] <- 1
  first_date_matrix_filtered_scaled[i, !is.na(first_date_matrix_filtered[i,]) & first_date_matrix_filtered[i,] >= time_window_10_to_200_cases[i] ] <- 2
}

first_date_matrix_filtered_scaled[is.na(first_date_matrix_filtered)] <-4

# data frame for clustering
df <- NULL
df$chosen_countries <- countries_with_measures
df$Anticipatory_measures <- rowSums(first_date_matrix_filtered_scaled == 0)
df$Early_measures <- rowSums(first_date_matrix_filtered_scaled == 1)
df$Late_measures <- rowSums(first_date_matrix_filtered_scaled == 2)

df <- as.data.frame(df)
df$chosen_countries <- as.character(df$chosen_countries)

# ************** KMEANS *************
# optimal number of clusters
wssplot <- function(data, nc=15, seed=1)
{
    wss <- (nrow(data)-1)*sum(apply(data,2,var))
    for (i in 2:nc)
    {
       set.seed(seed)
       wss[i] <- sum(kmeans(data, centers=i,iter.max = 10000)$withinss)
    }
    plot(1:nc, wss, type="b", xlab="Number of groups",
         ylab="Sum of squares within a group", main = "The optimal number of clusters k")
}
 
optimal_number_k_plot <- wssplot(df[,c(2:(ncol(df)))], nc = 15)
# *********************************
 
NUMBER_OF_CLUSTERS <- 8
cluster.results <- kmeans(df[,c(2:ncol(df))], NUMBER_OF_CLUSTERS , nstart = 20, iter.max = 10000)
cluster.results

countries_with_measures[which(cluster.results$cluster==1)]
countries_with_measures[which(cluster.results$cluster==2)]
countries_with_measures[which(cluster.results$cluster==3)]
countries_with_measures[which(cluster.results$cluster==4)]
countries_with_measures[which(cluster.results$cluster==5)]
countries_with_measures[which(cluster.results$cluster==6)]
countries_with_measures[which(cluster.results$cluster==7)]
countries_with_measures[which(cluster.results$cluster==8)]

# data frame for plotly
df$KM <- cluster.results$cluster
df$size <- df$Anticipatory_measures + df$Early_measures + df$Late_measures
df$KM <- as.factor(df$KM)
df$size <- (df$size/max(df$size))

# Create the plot
# text
t <- list(
 family = "Helvetica")

p  <- NULL
p <- plot_ly(
 df, x = ~Late_measures, y = ~Early_measures, z = ~Anticipatory_measures,
 size = ~df$size,
 marker = list(symbol = 'circle', sizemode = 'diameter'), sizes = c(7, 30),
 color = ~KM, colors = c('#008000', '#0C4B8E', '#FF0000', '#FFA500', '#808080'),
 mode = 'markers'
 ) %>%
 add_markers() %>%
 layout(
  scene = list(xaxis = list(title = 'Late measures'),
                yaxis = list(title = 'Early measures'),
                zaxis = list(title = 'Anticipatory measures'),
               textfont = list(color =  'grey', size = 20, family = "Helvetica" ),
               camera = list(eye = list(x=1.25, y=1.3, z = 1.5)))
 ) 
p = add_trace(p, x = ~Late_measures, y = ~Early_measures, z = ~Anticipatory_measures,
             mode = 'text+markers', text = ~chosen_countries,
             textfont = list(color =  'grey', size = 12, family = "Helvetica" ), showlegend = FALSE) 

# `line.width` does not currently support multiple values. - 
#  error after chosing color and size based on value of varibales
#  https://github.com/ropensci\

p

htmlwidgets::saveWidget(as_widget(p), "CountryClusters.html")

