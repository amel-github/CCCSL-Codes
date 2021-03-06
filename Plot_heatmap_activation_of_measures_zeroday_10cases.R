##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Clustering of countries based on implemented measures
## Script purpose: This script makes a heatmap based on time of implementation of measures
## Date:12.07.2020.
## Authors:  Elma Hot Dervic
## Modified by David Garcia
##################################################

library(reshape2)
library(ggplot2)
library(RColorBrewer)

# matrix - each country is presented with one row
# each NPI is presented with one column
# time of implentation is presented with epidemic age
# zero day is defined as day with 10 cases (the script indicates which command to change to modifiy t0)

first_date_matrix <- matrix(NA, nrow=length(countries_with_measures), ncol=(ncol(measures)-2))
min_date_10_cases <- rep(0, length(countries_with_measures))

for(i in 1:length(countries_with_measures)) {
  country.name <- countries_with_measures[i]
  onecountry_measures <- measures[measures$Country==country.name, ]
  JH_data_one_country <-  JH_data %>% filter(country == country.name)
  date_cases <- JH_data_one_country$date[JH_data_one_country$cases>=10]

  # use: date_cases <- JH_data_one_country$date[JH_data_one_country$cases>=100] for t0 = day when 100 cases are reported
  # use: date_cases <- JH_data_one_country$date[JH_data_one_country$cases>=200] for t0 = day when 200 cases are reported

    if(length(date_cases)!=0){
    min_date_10_cases[i] <- min(date_cases) # change min_date_10_cases[i] to min_date_100_cases[i] or min_date_200_cases[i]
    if(nrow(JH_data_one_country)>1 & nrow(onecountry_measures)>0){
      for(j in 3:dim(measures)[2]){
        if(sum(onecountry_measures[,j])>0){
          min_date <- min(onecountry_measures$Date[onecountry_measures[,j]])
          if(!is.na(min_date) & !is.na(min_date_10_cases[i])){i     # change min_date_10_cases[i] to min_date_100_cases[i] or min_date_200_cases[i]
            min_date <- as.Date(min_date)
            first_date_matrix[i,(j-2)] <- as.numeric(min_date - min_date_10_cases[i])    # change min_date_10_cases[i] to min_date_100_cases[i] or min_date_200_cases[i]
          } }
      } } } } 

# matrix to da frame
data_for_plot <- as.data.frame(first_date_matrix)
names(data_for_plot) <- names_l2
data_for_plot$Country <- countries_with_measures

# melt the data frame
df <- melt(data_for_plot ,  id.vars = c('Country'), variable.name = 'Measures')
names(df) <- c("Country", "Measures","Time_difference_Days"  )

# add L1 category to L2 measures
# need for ploting
names_l1_l2 <- data.frame(names_l1, names_l2, stringsAsFactors = F)
df <- merge(df, names_l1_l2, by.x = "Measures", by.y ="names_l2")

df <- df[order(df$names_l1),]
df$names_l1 <- as.factor(df$names_l1)

# make vector of colors 
# one color for each L1 level
# use color palette "Dark2"
cols <- brewer.pal(length(unique(names_l1)),"Dark2")
x <- table(names_l1_l2$names_l1)
x <- unname(x)
col <- NULL
for(i in 1:length(x)){
  col <- c(col, rep(cols[i], x[i]))
}

plot <- ggplot(df, aes(Country, Measures,  fill= Time_difference_Days)) + 
  geom_tile() +
  scale_fill_gradient(low="lightgreen", high="red", na.value="darkgray", breaks=c(-75, -50, -25, 0, 25, 50, 75)) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, face = "bold"), 
        axis.text.y = element_text(colour = col, size = 8, face = "bold"),
        text = element_text(family = "Helvetica")) +
  guides(fill=guide_legend(title="Time difference [Days]"))            
name <- "Measures_Countries_time_of_activation_zeroday10cases.png"
ggsave(plot,  file = name,  width = 33*1.25, height = 27 *1.25, units = "cm", dpi=1200) 
name <- "Measures_Countries_time_of_activation_zeroday10cases.eps"
ggsave(plot,  file = name,  width = 33*1.25, height = 27 *1.25, units = "cm", dpi=1200) 
 
# Warning message:
# Vectorized input to `element_text()` is not officially supported.
# Results may be unexpected or may change in future versions of ggplot2.

# show the saved plot
print(plot)

