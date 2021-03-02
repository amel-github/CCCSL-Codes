CCCSL: Complexity Science Hub COVID-19 Control Strategies List – Codes
for exploration and visualisation
================
Update 2021-03-02

[Purpose](#Purpose)  
[Background & Summary of the
Project](#Background%20&%20Summary%20of%20the%20Project)  
[About the Data](#Data)  
[Technical Validation of the CCCSL
Dataset](#Technical%20Validation%20of%20the%20CCCSL%20Dataset)  
[Description of the CCCSL
Dataset](#Description%20of%20the%20CCCSL%20Dataset)  
[Usage example of the CCCSL Dataset \#1: Number of interventions versus
incidence of COVID-19](#Usage1)  
[Usage example of the CCCSL Dataset \#2: Interactive world map of the
number of interventions per country](#Usage2)  
[Usage example of the CCCSL Dataset \#3: Visualisation of the
time-series of the date of NPI implementation using a heat
map](#Usage3)  
[Usage example of the CCCSL Dataset \#4: Country-cluster analysis of the
control strategies](#Usage4)  
[Usage examples \#3 and \#4: Getting Started](#Getting%20Started)  
[Authors](#Authors)  
[License](#License)  
[Acknowledgements](#Acknowledgements)  
[Funding](#Funding) [Contact](#Contact)

## Purpose <a name="Purpose"></a>

The codes provided here enable users to validate, explore, describe, and
visualise the [CCCSL
dataset](https://github.com/amel-github/covid19-interventionmeasures).
<br> \* Usages \#1 and \#2: The codes enable to reproduce the map as
well as the bubble and bar plots displayed on our
[webpage](http://covid19-interventions.com/).<br> \* Usages \#2 and \#3:
The codes enable to reproduce the figures presented in our
[publication](https://doi.org/10.1038/s41597-020-00609-9).

## Background & Summary of the Project <a name="Background & Summary of the Project"></a>

In response to the COVID-19 pandemic, governments have implemented a
wide range of public health and social measures (PHSMs), also called
non-pharmaceutical interventions (NPIs). Monitoring and documenting
government strategies during the COVID-19 crisis is crucial to
understand the progression of the epidemic. <br> The Complexity Science
Hub COVID-19 Control Strategies List (CCCSL) project aims to generate a
comprehensive and structured dataset on government responses to
COVID-19, including the respective time schedules of their
implementation.

The project webpage is accessible
[here](http://covid19-interventions.com/).

## About the Data <a name="Data"></a>

Our dataset presents PHSMs but also economic measures (EMs) implemented
in response to COVID-19. <br>

A dynamic version of the CCCSL dataset, which is continually updated,
can be accessed via
[GitHub](https://github.com/amel-github/covid19-interventionmeasures).

A static version of the dataset is provided on this repository.

Our methodology is published: Desvars-Larrive, A., Dervic, E., Haug, N.
et al. A structured open dataset of government interventions in response
to COVID-19. *Scientific Data* 7, 285 (2020).
<https://doi.org/10.1038/s41597-020-00609-9>.

## Technical Validation of the CCCSL Dataset <a name="Technical Validation of the CCCSL Dataset"></a>

Three R scripts can be run to perform automated validations and
summaries of the dataset:

  - To check that there are no duplicated entries:
    [Validation/CheckDuplicates.R](Validation/CheckDuplicates.R)

  - To generate the master list of codes:
    [Validation/GenerateMasterLists\_CCCSL.R](Validation/GenerateMasterLists_CCCSL.R)

  - To check for consistency in codes:
    [Validation/CheckUniqueCombinations.R](Validation/CheckUniqueCombinations.R)

## Description of the CCCSL Dataset <a name="Description of the CCCSL Dataset"></a>

File: [Description\_CCCSL\_v2.Rmd](Description_CCCSL_v2.Rmd) <br> These
codes are provided in form of R Markdown document. <br> To see all the
results, knit it to .pdf (default output).  
Explanation for the codes are displayed in the R Markdown documents.

## Usage example of the CCCSL Dataset \#1: Interactive world map of the number of interventions per country <a name="Usage1"></a>

This map shows the number of government interventions per country that
are reported in the CCCSL dataset. <br> File: [WorldMap.R](WorldMap.R)
<br> Output: Interactive html-map

## Usage example of the CCCSL Dataset \#2: Number of interventions versus incidence of COVID-19 <a name="Usage2"></a>

This script enables to plot the number of reported interventions (theme
level/L1\_Measures) in the CCCSL dataset per country and per day in form
of bubbles/horizontal lines and compared it with the smoothed
linear/logarithmic progress of daily new COVID-19 confirmed cases per
million people.

  - Results and visualizations can be produced by running
    [Main\_program.R](Main_program.R).

  - Below, follows a short description of the different files:

<!-- end list -->

1.  [Functions.R](Functions.R): contains the functions used by the
    various algorithms.

2.  [Plot\_options](Plot_options): contains the format settings for the
    plots.

3.  [Plot\_L1-measures\_timeline\_bubbles.R](Plot_L1-measures_timeline_bubbles.R):
    produces one graph containing all the countries and one graph for
    every country within the CCCSL dataset showing the number of
    implemented government interventions per day and per L1-category as
    bubbles over a timeline.

4.  [Plot\_L1-measures\_timeline\_lines.R](%5BPlot_L1-measures_timeline_lines.R):
    produces three graphs containing all the countries and one graph for
    every country within the CCCSL dataset showing the number of
    implemented government measures per day and per L1-category over a
    timeline.

5.  [Combine\_timeline\_plots.R](): combines the bubbles and timeline \#
    graphs into one graphical file.

We used data on the number of COVID-19 cases provided by [Our World in
Data](https://github.com/owid/covid-19-data).

## Usage example of the CCCSL Dataset \#3: Visualisation of the time-series of the date of NPI implementation using a heat map <a name="Usage3"></a>

We propose to visualise the time series of the dates of implementation
of the NPIs recorded in the CCCSL at level 2 (categories) in the 56
countries using a heat map. To highlight country-based differences in
the timeline of implementation thorough the epidemic, we used the
epidemic age instead of calendar time and considered t0 as the day when
the number of confirmed cases reaches 10.

We used the time-series of the number of COVID-19 cases provided by the
Johns Hopkins University Center for Systems Science and Engineering,
accessible via Github: <https://github.com/CSSEGISandData/COVID-19>.
<br>

## Usage example of the CCCSL Dataset \#4: Country-cluster analysis of the control strategies <a name="Usage4"></a>

The cluster analysis partitions the countries on the aggressiveness of
the control strategy (number of measures) and responsiveness (timeline).
We focused on the compulsory measures (i.e. theme “Risk communication”
was not included) recorded in the CCCSL at level 2 (categories) that
appeared in at least 15 countries.<br>

Method used: k-means clustering. The clustering algorithm used the date
of implementation of the interventions in each country, based on the
epidemic age. We considered: <br>

  - “Anticipatory measures” as those implemented before day when 10
    cases were reported; <br>

  - “Early measures” as those implemented at the beginning of the
    epidemic, i.e. between day when 10 cases were reported and day when
    200 cases were reported; <br>

  - “Late measures” as those implemented in a later stage of the
    epidemic, i.e. after day when 200 cases were reported. The algorithm
    also takes into account the number of measures implemented at these
    different epidemic ages. <br>

We used the time-series of the number of COVID-19 cases provided by the
Johns Hopkins University Center for Systems Science and Engineering,
accessible via Github: <https://github.com/CSSEGISandData/COVID-19>.
<br>

## Usage examples \#3 and \#4: Getting Started <a name="Getting Started"></a>

These instructions will get you a copy of the project up and running on
your local machine for testing purposes.

### Prerequisites

  - Installed/updated R (R version 3.6.1 (2019-07-05) ) and RStudio
    (Version 1.2.1335 © 2009-2019 RStudio, Inc.)

### Installing

Install and load packages:

  - countrycode (1.1.1)

  - dplyr (0.8.5)

  - factoextra (1.0.7)

  - ggplot2 (3.3.0)

  - plot3D (1.3)

  - plotly (4.9.2.1)

  - RColorBrewer (1.1-2)

  - reshape2 (1.4.3)

  - reticulate (1.15)

  - stringr (1.4.0)

  - tidyverse (1.3.0)

  - vegan (2.5-6)

  - incidence (1.7.0)

  - RColorBrewer (1.1-2)

  - kableExtra (1.1.0)

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

Results and visualizations can be produced by running
[Main\_Script.Rmd](Main_Script.Rmd). Below you can find a list of the
steps of our analysis and visualization.

#### Step 1

This script creates binary representations of the CCCSL data set on
category (L2) \*
[make\_binary\_measure\_tables.R](make_binary_measure_tables.R)

#### Step 2

Download the data from [COVID-19 Data Repository by the Center for
Systems Science and Engineering (CSSE) at Johns Hopkins
University](https://github.com/CSSEGISandData/COVID-19) \*
[Get\_JohnsHopkins\_data.R](Get_JohnsHopkins_data.R)

#### Step 3

Read data from the binary file take names of all countries, all L1
measures, all L2 measures. \*
[Get\_measures\_data.R](Get_measures_data.R)

#### Step 4

Heat map of the timeline of NPI implementation by country. We used the
epidemic age instead of calendar time and considered t0 as the day when
the number of confirmed cases reaches 10.

To plot and save the
Measures\_Countries\_time\_of\_activation\_zeroday10cases.png and
Measures\_Countries\_time\_of\_activation\_zeroday10cases.eps \*
[Plot\_heatmap\_activation\_of\_measures\_zeroday\_10cases.R](Plot_heatmap_activation_of_measures_zeroday_10cases.R)

#### Step 5

In order to partition the countries based on the aggressiveness of the
control strategy (number of measures) and responsiveness (timeline), we
propose a [k-means clustering method](https://doi.org/10.3390/j2020016).

To calculate the clustering and visualise the results, run
[Clustering\_kmeans.R](Clustering_kmeans.R)<br>

Each country is characterised with regard to the number of anticipatory,
early, and late measures.<br> x-axis: late measures;<br> y-axis: early
measures;<br> z-axis: anticipatory measures.

An interactive version of the clustering graph is available online at:
[http://covid19-interventions.com/CountryClusters.html.](http://covid19-interventions.com/CountryClusters.html)

## Authors <a name="Authors"></a>

  - [Elma Hot Dervic](https://github.com/elmame)
  - [Nils Haug](https://github.com/nmhaug)
  - [Amélie Desvars-Larrive](https://github.com/amel-github)
  - Michael Gruber
  - [David Garcia](https://github.com/dgarcia-eu)

See also the list of
[contributors](https://github.com/amel-github/covid19-interventionmeasures#List%20of%20Contributors)
who participated in this project.

## License <a name="License"></a>

This project is licensed under the CC BY-SA 4.0 License - see the [CC
BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en) file
for details.

## Acknowledgements <a name="Acknowledgements"></a>

  - This work is coordinated by the [Complexity Science Hub Vienna,
    Austria](https://www.csh.ac.at). <br>
  - This work is supported by the [University of Veterinary Medicine
    Vienna, Austria](https://www.vetmeduni.ac.at/).<br>
  - The authors acknowledge Petar Sekulic for his advice on the
    analyses. We warmly thank Caspar Matzhold and Michaela Kaleta for
    checking and testing our code components.

## Funding <a name="Funding"></a>

EOSCsecretariat.eu has received funding from the European Union’s
Horizon Programme call H2020-INFRAEOSC-05-2018-2019, grant Agreement
number 831644.

## Contact <a name="Contact"></a>

Amélie Desvars-Larrive (Complexity Science Hub Vienna, Austria /
University of Veterinary Medicine Vienna, Austria). <br> Email:
[desvars@csh.ac.at]()
