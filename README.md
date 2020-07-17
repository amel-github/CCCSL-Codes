# A structured open dataset of government interventions in response to COVID-19 -- Codes for exploration and visualisation - Version 2

## Background & Summary of the Project
In response to the COVID-19 pandemic, governments have implemented a wide range of non-pharmaceutical interventions (NPIs). Monitoring and documenting government strategies during the COVID-19 crisis is crucial to understand the progression of the epidemic. The Complexity Science Hub COVID-19 Control Strategies List (CCCSL) project aims to generate a comprehensive and structured dataset on government responses to COVID-19, including the respective time schedules of their implementation, precise and flexible enough to enable a global use in support of the fight against COVID-19.<br>

Our paper is available here: https://www.medrxiv.org/content/10.1101/2020.05.04.20090498v1

The project webpage is accessible here: http://covid19-interventions.com/.<br>

A dynamic version of the dataset, which is continually updated, can be accessed via Github: https://github.com/amel-github/covid19-interventionmeasures

The codes provided here enable users to explore and visualise the CCCSL dataset.<br>

A static version of the dataset is provided on this repository.

## Description of the CCCSL Dataset
File: [Description_CCCSL_v2.Rmd](Description_CCCSL_v2.Rmd)<br>
These codes are provided in form of R Markdown document. To see all the results, knit it to .pdf (default output).<br>
Explanation for the codes are displayed in the R Markdown documents.

## Technical validation
Three R scripts can be run to perform automated validations and summaries of the dataset:

* To check that there are no duplicated entries: [Validation/CheckDuplicates.R](Validation/CheckDuplicates.R)

* To generate the master list of codes: [Validation/GenerateMasterLists_CCCSL.R](Validation/GenerateMasterLists_CCCSL.R)

* To check for consistency in codes: [Validation/CheckUniqueCombinations.R](Validation/CheckUniqueCombinations.R)

## Usage example of the CCCSL Dataset #1: Visualisation of the time-series of the date of NPI implementation using a heat map
We propose to visualise the time series of the dates of implementation of the NPIs recorded in the CCCSL at level 2 (categories) in the 56 countries using a heat map. To highlight country-based differences in the timeline of implementation thorough the epidemic, we used the epidemic age instead of calendar time and considered t0 as the day when the number of confirmed cases reaches 10.

We used the time-series of the number of COVID-19 cases provided by the Johns Hopkins University Center for Systems Science and Engineering, accessible via Github: https://github.com/CSSEGISandData/COVID-19. <br>

## Usage example of the CCCSL Dataset #2: Country-cluster analysis of the control strategies
The cluster analysis partitions the countries on the aggressiveness of the control strategy (number of measures) and responsiveness (timeline). We focused on the compulsory measures (i.e. theme “Risk communication” was not included) recorded in the CCCSL at level 2 (categories) that appeared in at least 15 countries.<br>

Method used: k-means clustering. The clustering algorithm used the date of implementation of the interventions in each country, based on the epidemic age. We considered: <br>

- "Anticipatory measures" as those implemented before day when 10 cases were reported; <br>

- "Early measures" as those implemented at the beginning of the epidemic, i.e. between day when 10 cases were reported and day when 200 cases were reported; <br>

- "Late measures" as those implemented in a later stage of the epidemic, i.e. after day when 200 cases were reported. The algorithm also takes into account the number of measures implemented at these different epidemic ages. <br>

We used the time-series of the number of COVID-19 cases provided by the Johns Hopkins University Center for Systems Science and Engineering, accessible via Github: https://github.com/CSSEGISandData/COVID-19. <br>


##  Usage examples of the CCCSL Dataset: Getting Started

These instructions will get you a copy of the project up and running on your local machine for testing purposes. 

### Prerequisites

* Installed/updated R (R version 3.6.1 (2019-07-05) ) and RStudio (Version 1.2.1335
© 2009-2019 RStudio, Inc.)

### Installing

Install and load packages:

* countrycode (1.1.1)

* dplyr (0.8.5)

* factoextra (1.0.7)

* ggplot2 (3.3.0)

* plot3D (1.3)

* plotly (4.9.2.1)

* RColorBrewer (1.1-2)

* reshape2 (1.4.3)

* reticulate (1.15)

* stringr  (1.4.0)

* tidyverse (1.3.0)

* vegan (2.5-6)

* incidence (1.7.0)

* RColorBrewer (1.1-2)

* kableExtra (1.1.0)

To automatically install all packages, run the following:

```
my_packages <- c("countrycode", "dplyr", "factoextra", "ggplot2", "plot3D", "plotly", 
                 "reshape2", "reticulate", "stringr", "svglite", "tidyverse", "vegan",
                 "incidence", "stringr","RColorBrewer", "kableExtra")  

# Extract not installed packages
not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]    

# Install not installed packages
if(length(not_installed)) install.packages(not_installed)                           
```

## Running the tests

Results and visualizations can be produced by running  [Main_Script.Rmd](Main_Script.Rmd). Below you can find a list of the steps of our analysis and visualization.

#### Step 1
This script creates binary representations of the CCCSL data set on category (L2)
 * [make_binary_measure_tables.R](make_binary_measure_tables.R)
 
#### Step 2
Download the data from [COVID-19 Data Repository by the Center for Systems Science and Engineering (CSSE) at Johns Hopkins University](https://github.com/CSSEGISandData/COVID-19)
 * [Get_JohnsHopkins_data.R](Get_JohnsHopkins_data.R)
 
####  Step 3
Read data from the binary file take names of all countries, all L1 measures, all L2 measures.
 * [Get_measures_data.R](Get_measures_data.R)
 
#### Step 4
Heat map of the timeline of NPI implementation by country.
We used the epidemic age instead of calendar time and considered t0 as the day when the number of confirmed cases reaches 10.

To plot and save the Measures_Countries_time_of_activation\_zeroday10cases.png and Measures_Countries_time_of_activation_zeroday10cases.eps
* [Plot_heatmap_activation_of_measures_zeroday_10cases.R](Plot_heatmap_activation_of_measures_zeroday_10cases.R)

#### Step 5
In order to partition the countries based on the aggressiveness of the control strategy (number of measures) and responsiveness (timeline), we propose a [k-means clustering method](https://doi.org/10.3390/j2020016).

To calculate the clustering and visualize the results, run [Clustering_kmeans.R](Clustering_kmeans.R)<br>
 
Each country is characterised with regard to the number of anticipatory, early, and late measures.<br>
x-axis: late measures;<br>
y-axis: early measures;<br>
z-axis: anticipatory measures.

An interactive version of [Fig. 3](Clustering_kmeans_static.svg) is available online at: [http://covid19-interventions.com/CountryClusters.html.](http://covid19-interventions.com/CountryClusters.html)


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
* This work is supported by the University of Veterinary Medicine Vienna, Austria.
* The authors acknowledge Petar Sekulic for his advice on the analyses. We warmly thank Caspar Matzhold and Michaela Kaleta for checking and testing our code components.

