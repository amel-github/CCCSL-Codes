##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Network - overlap of measures in time
## Script purpose: make graph file (.gexf)
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

edges_m <- as.matrix(which(Overlap>0, arr.ind = T))
edgesWeight <- Overlap[Overlap>0]
# str(edges_m)

edges_m <- edges_m[complete.cases(edges_m),]
edgesWeight <- edgesWeight[complete.cases(edgesWeight)]
# str(edges_m)
# str(edgesWeight)


edges_all_filter <- cbind(edges_m, edgesWeight)
# str(edges_all_filter)
edges_all_filter <- as.data.frame(edges_all_filter)
# str(edges_all_filter)
names(edges_all_filter) <- c("Source", "Target", "edgesWeight")

# sum(duplicated(edges_all_filter[,c(1,2)]))

edges_all_filter <- edges_all_filter[complete.cases(edges_all_filter),]
# sum(duplicated(edges_all_filter[,c(1,2)]))
# str(edges_all_filter)
edges_all_filter <- edges_all_filter[edges_all_filter$edgesWeight>0.5,]

# SCALE LINKS WEIGHT
# edges_all_filter$edgesWeight <- edges_all_filter$edgesWeight/max(edges_all_filter$edgesWeight)*10


# make data frames for write.gexf funtion
# edges - two colums data frame
edges <- edges_all_filter[, c(1,2)]
# str(edges)


# str(nodes)
# str(nodes_color)
# str(nodes_size)
# str(position)
# str(node_att_names_l1)

# SCALE SIZE of nodes
nodes_size <- nodes_size/max(nodes_size)*5
# change min size od nodes
# make small nodes visiable in gexf
# nodes_size <- nodes_size + 5



# make GEXF file
g1 <- write.gexf(nodes, edges,  edgesWeight = edges_all_filter$edgesWeight, nodesVizAtt = list( color = nodes_color, size=nodes_size,  position=position), nodesAtt = node_att_names_l1, defaultedgetype = "directed")
# save GEXF file
f <- file("Overlap_measure_graph.gexf")
writeLines(g1$graph, con = f)
close(f)


# ************************* FILTER LINKS *************************
# filter links bigger links 
# make data frames for write.gexf funtion
# edges - two colums data frame


nodes <- nodes[nodes_size>2,]
nodes_color <- nodes_color[nodes_size>2,]
node_att_names_l1 <- node_att_names_l1[nodes_size>2,]
position <- position[nodes_size>2,]
nodes_size <- nodes_size[nodes_size>2]



edges_all_filter1 <- edges_all_filter[edges_all_filter$Source %in%  nodes$id & edges_all_filter$Target %in%  nodes$id,]
# str(edges_all_filter1)


edges_all_filter1 <- edges_all_filter1[edges_all_filter1$edgesWeight>0.5,]
edges <- edges_all_filter1[, c(1,2)]
# str(edges)


g1 <- write.gexf(nodes, edges,  edgesWeight = edges_all_filter1$edgesWeight, nodesVizAtt = list( color = nodes_color, size=nodes_size, position=position), nodesAtt = node_att_names_l1, defaultedgetype = "directed")

f <- file("Overlap_Filtered_measure_graph.gexf")
writeLines(g1$graph, con = f)
close(f)


