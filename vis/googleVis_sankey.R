# Data source: http://goo.gl/vcKo6y
UKvisits <- data.frame(origin=c(
  "France", "Germany", "USA",
  "Irish Republic", "Netherlands",
  "Spain", "Italy", "Poland",
  "Belgium", "Australia", 
  "Other countries", rep("UK", 5)),
  visit=c(
    rep("UK", 11), "Scotland",
    "Wales", "Northern Ireland", 
    "England", "London"),
  weights=c(
    c(12,10,9,8,6,6,5,4,4,3,33)/100*31.8, 
    c(2.2,0.9,0.4,12.8,15.5)))
## Uncomment the next 3 lines to install the developer version of googleVis
# install.packages(c("devtools","RJSONIO", "knitr", "shiny", "httpuv"))
# library(devtools)
# install_github("mages/googleVis")
require(googleVis)
plot(
  gvisSankey(UKvisits, from="origin", 
             to="visit", weight="weight",
             options=list(
               height=250,
               sankey="{link:{color:{fill:'lightblue'}}}"
             ))
)

require(igraph)
require(googleVis)
g <- graph.tree(24, children = 4)
set.seed(123)
E(g)$weight = rpois(23, 4) + 1
edgelist <- get.data.frame(g) 
colnames(edgelist) <- c("source","target","value")
edgelist$source <- LETTERS[edgelist$source]
edgelist$target <- LETTERS[edgelist$target]

plot(
  gvisSankey(edgelist, from="source", 
             to="target", weight="value",
             options=list(
               sankey="{link: {color: { fill: '#d799ae' } },
                        node: { width: 4, 
                                color: { fill: '#a61d4c' },
                                label: { fontName: 'Times-Roman',
                                         fontSize: 14,
                                         color: '#871b47',
                                         bold: true,
                                         italic: true } }}"))
)