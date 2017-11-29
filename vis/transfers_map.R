library(riverplot)
library(reshape2)

source("./chorddiag.R")
source("./clean_fice_coords.R")

m = format_transfers()

# Put nodes data in riverplot format
nodes = data.coords

# m in chordiag.R$format_transfers
edges = cbind(expand.grid(dimnames(m)), value = as.vector(m))

# Drop edges with no transfers
edges = edges[edges$value>0,]

edges$direction = as.factor(rep('A', nrow(edges)))

colnames( nodes ) <- c( "ID", "y", "x" )
colnames( edges ) <- c( "N1", "N2", "Value", "direction" )

edges$N1 = as.character(edges$N1)
edges$N2 = as.character(edges$N2)

# color the edges by troop movement direction
edges$col <- c( "#e5cbaa", "black" )[ factor( edges$direction ) ]
# color edges by their color rather than by gradient between the nodes
edges$edgecol <- "col"

edges = as.data.frame(edges)
nodes = as.data.frame(nodes)

# Filter
fices = c('012826', '003658', '003644')
#edges = edges[edges$Value > 100 & (edges$N1 %in% fices | edges$N2 %in% fices),]
edges = edges[(edges$N1 %in% fices & edges$N2 %in% fices),]
#fices = unique(c(edges$N1, edges$N2))
nodes = nodes[nodes$ID %in% fices,]

# generate the riverplot object
river <- makeRiver( nodes, edges )

style <- list( edgestyle= "sin", nodestyle= "point" )

# plot the generated object
plot( river, lty= 1, default.style= style )

points( data.coords$long, data.coords$lat, pch= 19 ) 