##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Network - overlap of measures in time
## Script purpose: This scripts make nodes for the network
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


# ************************* NODES *************************
numer_of_measures <- length(names_l2)
nodes <- NULL
nodes$label <- names_l2
nodes$id <- c(1:numer_of_measures)
nodes <- as.data.frame(nodes)
# str(nodes)
# first column ID, second column LABEL
nodes <- nodes[,c(2,1)]
nodes$label <- as.character(nodes$label)


# set colors based on L1 level
# x size of each L1 level
x <- table(names_l1)
x <- unname(x)

# define colors
r <- c(0, 88, 150, 180, 191, 255, 255)
g <- c(0, 242, 29, 202, 0, 128, 255)
b <- c(255, 26, 26, 242, 255, 0, 0)

nodes_color_r <- NULL
nodes_color_g <- NULL
nodes_color_b <- NULL
for(i in 1:length(unique(names_l1))){
nodes_color_r <- c(nodes_color_r, rep(r[i], x[i]) )
nodes_color_g <-  c(nodes_color_g, rep(g[i], x[i]) )
nodes_color_b <- c(nodes_color_b, rep(b[i], x[i]) )
}
nodes_color <- data.frame( r=nodes_color_r, g = nodes_color_g, b = nodes_color_b)
# nodes_color
nodes_color$alpha <- rep(1, numer_of_measures)
nodes_color <- as.data.frame(nodes_color)
# str(nodes_color)

# count number of countries for each measure
matrix_for_size  <- rep(0, numer_of_measures)
for(i in countries_with_measures){
  onecountry_measures <- measures[measures$Country==i,]
  onecountry_measures <- unname(onecountry_measures[,3:dim(measures)[2]])
  matrix_for_size[which(colSums(onecountry_measures)>0)] <- matrix_for_size[which(colSums(onecountry_measures)>0)] + 1
}
# set smallest nodes to 1 (avoid 0)
nodes_size <- matrix_for_size + 1

# read positions 
# save positions from GEPHI file
# number of nodes: 77

position <- readRDS("NODES_position_from_Gephi.rds")
position <- position[order(position$id),]
position$id <- NULL
position$label_old <- NULL
position$z <- rep(0, nrow(position))
names(position) <- c("x", "y", "z")
position$x <- as.numeric(position$x)
position$y <- as.numeric(position$y)
# str(position )


# str(nodes)
# str(nodes_color)
# str(nodes_size)
# str(position)

# add one more attribute to nodes
node_att_names_l1 <- NULL
node_att_names_l1$L1 <- as.character(names_l1)
node_att_names_l1$id <- c(1:length(names_l1))
node_att_names_l1 <-  as.data.frame(node_att_names_l1)
node_att_names_l1$L1 <- as.character(node_att_names_l1$L1)
# str(node_att_names_l1)



# str(nodes)
# str(nodes_color)
# str(nodes_size)
# str(position)
# str(node_att_names_l1)

