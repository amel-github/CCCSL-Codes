# A structured open dataset of government interventions in response to COVID-19 -- Codes for exploration and visualisation

## Background & Summary of the Project
In response to the COVID-19 pandemic, governments have implemented a wide range of non-pharmaceutical interventions (NPIs). Monitoring and documenting government strategies during the COVID-19 crisis is crucial to understand the progression of the epidemic. The Complexity Science Hub COVID-19 Control Strategies List (CCCSL) project aims to generate a comprehensive and structured dataset on government responses to COVID-19, including the respective time schedules of their implementation, precise and flexible enough to enable a global use in support of the fight against COVID-19.<br>

Our paper is available here: https://www.medrxiv.org/content/10.1101/2020.05.04.20090498v1

The project webpage is accessible here: http://covid19-interventions.com/.<br>

A dynamic version of the dataset, which is continually updated, can be accessed via Github: https://github.com/amel-github/covid19-interventionmeasures

The codes provided here enable users to explore and visualise the CCCSL dataset.<br>


## Citation
If you use these codes, please cite doi: XXXXXX.


## Description of the CCCSL Dataset
File Description_CCCSL_v2.Rmd<br>
These codes are provided in form of R Markdown documents. The default output is .html.<br>
Explanation for the codes are displayed in the R Markdown documents.


## Usage example of the CCCSL Dataset #1: Visualisation of the time-series of the date of NPI implementation using a heat map (Step 4)
We propose to visualise the time series of the dates of implementation of the NPIs recorded in the CCCSL at level 2 (categories) in the 54 countries using a heat map. To highlight country-based differences in the timeline of implementation thorough the epidemic, we used the epidemic age instead of calendar time and considered t0 as the day when the number of confirmed cases reaches 10.

We used the time-series of the number of COVID-19 cases provided by the Johns Hopkins University Center for Systems Science and Engineering, accessible via Github: https://github.com/CSSEGISandData/COVID-19. <br>

## Usage example of the CCCSL Dataset #2: Country-cluster analysis of the control strategies (Step 5)
The cluster analysis partitions the countries on the aggressiveness of the control strategy (number of measures) and responsiveness (timeline). We focused on the compulsory measures (i.e. theme “Risk communication” was not included) recorded in the CCCSL at level 2 (categories) that appeared in at least 15 countries.<br>
Method used: k-means clustering: The clustering algorithm used the date of implementation of the interventions in each country, based on the epidemic age. We considered: <br>
- "anticipatory measures" as those implemented before day when 10 cases were reported; <br>
- "early measures" as those implemented at the beginning of the epidemic, i.e. between day when 10 cases were reported and day when 200 cases were reported; <br>
- "late measures" as those implemented in a later stage of the epidemic, i.e. after day when 200 cases were reported. The algorithm also takes into account the number of measures implemented at these different epidemic ages. <br>

We used the time-series of the number of COVID-19 cases provided by the Johns Hopkins University Center for Systems Science and Engineering, accessible via Github: https://github.com/CSSEGISandData/COVID-19. <br>


##  Usage examples of the CCCSL Dataset: Getting Started

These instructions will get you a copy of the project up and running on your local machine for testing purposes. 

### Prerequisites

* Installed/updated R (R version 3.6.1 (2019-07-05) ) and RStudio (Version 1.2.1335
© 2009-2019 RStudio, Inc.)

### Installing

Install and load packages:

* dplyr (0.8.5)

* factoextra (1.0.7)

* ggplot2 (3.3.0)

* plotly (4.9.2.1)

* RColorBrewer (1.1-2)

* reshape2 (1.4.3)

* reticulate (1.15)

* stringr  (1.4.0)

* svglite (1.2.3)

* tidyverse (1.3.0)

* vegan (2.5-6)


```
 my_packages <- c( "dplyr", "factoextra" , "ggplot2" , "plotly" , "RColorBrewer" ,
 "reshape2"   ,"reticulate" , "stringr" , "svglite" , "tidyverse"  , "vegan" )     
 
# Extract not installed packages                           
not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]    

# Install not installed packages
if(length(not_installed)) install.packages(not_installed)                               

```

## Running the tests

For all results run  [1_Run_This_Script_for_all_results.Rmd](1_Run_This_Script_for_all_results.Rmd) script.
#### Step 1
This script creates binary representations of the CCCSL data set on category level (L2)
 * [make_binary_measure_tables.R](make_binary_measure_tables.R)
#### Step 2
Download the data from [COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19)
 * [Get_JohnsHopkins_data.R](Get_JohnsHopkins_data.R)
####  Step 3
Read data from the binary file take names of all countries, all L1 measures, all L2 measures.
 * [Get_measures_data.R]([Get_measures_data.R])
#### Step 4
We propose to visualise the time series of the date of implementation of the measures recorded in the CCCSL at level 2 (categories) in the 52 countries using a heat map. To highlight country-based differences in the timeline of implementation thorough the epidemic, we used the epidemic age instead of calendar time and considered t0 as the day when the number of confirmed cases reaches 10.
To plot and save the Measures_Countries_time_of_activation\_zeroday10cases.png and Measures_Countries_time_of_activation_zeroday10cases.pdf
* [Plot_heatmap_activation_of_measures_zeroday_10cases.R](Plot_heatmap_activation_of_measures_zeroday_10cases.R)

t0 could be set to:
* the day when the number of confirmed cases reaches 100 cases
 [Plot_heatmap_activation_of_measures_zeroday_10cases.R](Plot_heatmap_activation_of_measures_zeroday_10cases.R)
* the day when the number of confirmed cases reaches 200 cases
 [Plot_heatmap_activation_of_measures_zeroday_200cases.R](Plot_heatmap_activation_of_measures_zeroday_200cases.R)
* the day with the first registered death 
 [Plot_heatmap_activation_of_measures_zeroday_10cases.R](Plot_heatmap_activation_of_measures_zeroday_10cases.R)
 
#### Step 4
 In order to partition the countries based on the aggressiveness of the control strategy (number of measures) and responsiveness (timeline), we propose a [k-means clustering method](https://en.wikipedia.org/wiki/K-means_clustering).

  
#####  The optimal number of cluster K

 The optimal number of cluster k, determined by optimizing the within-cluster sums of squares ([Elbow method](https://en.wikipedia.org/wiki/Elbow_method_(clustering)), was seven, explaining 80.3% of the variance ([Figure](OptimalNumber-K.png)).
 
 Each country is described with number of  "anticipatory measures" , "early measures" and "late measures".
 
 * [Clustering_kmeans.R](Clustering_kmeans.R)

 More details about the clustering: 
 [K-Means_analysis.pdf](K-Means_analysis.pdf)

## Result
 An interactive version of [Fig. 4](Clustering_kmeans_static.svg) is available online at: [http://covid19-interventions.com/CountryClusters.html.](http://covid19-interventions.com/CountryClusters.html)


## Authors

* [Elma Hot Dervic](https://github.com/elmame)
* [Nils Haug](https://github.com/nmhaug)
* [Amélie Desvars-Larrive](https://github.com/amel-github)
* [David Garcia](https://github.com/dgarcia-eu)


See also the list of [contributors](http://covid19-interventions.com) who participated in this project.

## License

This project is licensed under the 
CC BY-SA 4.0 License - see the [CC BY-SA 4.0d](https://creativecommons.org/licenses/by-sa/4.0/deed.en) file for details

## Acknowledgments

* This work was coordinated by the Complexity Science Hub Vienna, Austria
* The authors acknowledge William Schueller for his help in the recruitment of the team of data collectors and Petar Sekulic for his advises in the analysis. We warmly thank Caspar Matzhold and Michaela Kaleta for checking and testing our code components.
