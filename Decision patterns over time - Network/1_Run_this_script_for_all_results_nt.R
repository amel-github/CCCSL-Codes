##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Network - overlap of measures in time
## Script purpose: This scripts call all scripts from the project
## Date:12.04.2020.
## Authors:  Elma Hot Dervic, Nils Haug, Amélie Desvars-Larrive
##################################################


# Call first script 
# download raw data from github
# make binary file of measures data
# Install and load packages
my_packages <- c("reticulate", "dplyr", "stringr", "reshape2", "ggplot2", "RColorBrewer", 
                 "rgexf", "tidyverse", "igraph", "svglite")                                       
not_installed <- my_packages[!(my_packages %in% installed.packages()[ , "Package"])]    # Extract not installed packages
if(length(not_installed)) install.packages(not_installed)                               # Install not installed packages

# do not call new data
# work on static data!!
library("reticulate")
py_install("pandas", pip = TRUE)
py_install("networkx", pip = TRUE)
py_install("requests", pip = TRUE)
py_run_file("make_binary_measure_tables_nt.py")


source("Get_measures_data_nt.R")
source("Make_nodes.R")
source("Make_overlap_matrix.R")
source("Make_graph_file.R")
source("Plot_of_filtered_graph.R")


# plot interative filtered graph
plot(g1)

