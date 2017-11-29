library(edgebundleR)

# Create the graph object
g <- graph.data.frame(pairs[,1:2], directed=F, vertices=nodes)

edgebundle( g )