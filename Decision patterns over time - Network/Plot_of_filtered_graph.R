##################################################
## Project: CCCSL: Complexity Science Hub Covid-19 Control Strategies List (2020)
## Network - overlap of measures in time
## Script purpose: static plot of the network
## Date:12.04.2020.
## Authors:  Elma Hot Dervic, Nils Haug, Amélie Desvars-Larrive
##################################################

library(svglite)

nodes_size <- nodes_size/max(nodes_size) * 20
edges_all_filter1$edgesWeight <- edges_all_filter1$edgesWeight/max( edges_all_filter1$edgesWeight) * 5

g1 <- write.gexf(nodes, edges,  edgesWeight = edges_all_filter1$edgesWeight, nodesVizAtt = list( color = nodes_color, size=nodes_size, position=position), nodesAtt = node_att_names_l1, defaultedgetype = "directed")

library(igraph)
# Plotting
igraph1 <- gexf.to.igraph(g1)
# We set the mai = c(0,0,0,0) so we have more space for our plot
oldpar <- par(no.readonly = TRUE)
par(mai = rep(0,4))

plot(igraph1,
     vertex.size        = V(igraph1)$size,
     vertex.label.cex   = V(igraph1)$size/11,
     vertex.label.color = "black",
     edge.curved        = TRUE,
     edge.width         = E(igraph1)$weight,
     vertex.label.family = "Helvetica"
)
