###################################################
#
# Author: Michael Gruber, VetMedUni Wien, Dec. 2020
#
# This file contains the main program
#
###################################################

library(grid)
library(dplyr)
library(gtable)
library(magick)
library(scales)
library(ggpubr)
library(cowplot)
library(viridis)
library(relayer) # devtools::install_github("clauswilke/relayer")
library(ggplot2)
library(svglite)
library(lubridate)
library("rstudioapi")

cat("\014")
rm(list = ls())


###################################################################
########### Clear Environment and set Working Directory ###########
###################################################################

npi_file_name = "COVID19_non-pharmaceutical-interventions_version2_utf8.csv"

covid_file_name = "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv"


output_dir = "./"
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


###################################################################
####################### Import Functions ##########################
###################################################################

source("Functions.R")
source("Plot_options.R")


###################################################################
########### Import Dataset with NPIs and Format Dates #############
###################################################################

DATASET_NPI = read.csv(npi_file_name, colClasses=c("Country" = "character")) %>%
	dplyr::filter(Country != "Diamond Princess") %>%
	dplyr::mutate(iso3 = dplyr::case_when(iso3 == "USA" ~ "USA*", TRUE ~ as.character(iso3))) %>% # mark USA with asterisk
	dplyr::mutate(Date = as.Date(Date, format = "%Y-%m-%d")) %>%
	dplyr::mutate(Date2 = format(Date, "%Y-%m")) %>%
	dplyr::relocate(Date2, .after = Date)

names(DATASET_NPI)


###################################################################
#### Import Dataset with Covid-19 Statistics and Format Dates #####
###################################################################

DATASET_COVID = read.csv(covid_file_name) %>%
	dplyr::mutate(iso3 = dplyr::case_when(iso_code == "OWID_KOS" ~ "RKS", iso_code == "USA" ~ "USA*", TRUE ~ as.character(iso_code))) %>% # rename iso_code Kosovo,  mark USA with asterisk
	dplyr::relocate(iso3, .after = iso_code) %>%
	dplyr::filter(iso3 %in% unique(DATASET_NPI$iso3)) %>%
	dplyr::mutate(Date = as.Date(date, format = "%Y-%m-%d")) %>%
	dplyr::relocate(Date, .after = date)

names(DATASET_COVID)


###################################################################
######################## Perform Plots ############################
###################################################################

source("Plot_L1-measures_timeline_bubbles.R")
clear_workspace()

source("Plot_L1-measures_timeline_lines.R")
clear_workspace()

source("Plot_combine_timeline_plots.R")
clear_workspace()
