
library(circlize)
library(data.table)
library(reshape2)

setwd("/home/walling/dev/git/oncourse/vis")

data = fread("./data/fice_transfers.csv", na.strings = '#NULL!', colClass=c('character', rep('numeric', 113)))

# Drop last column 'Total'
data = data[,1:(ncol(data)-1)]

# Drop last 2 rows
data = data[1:(nrow(data)-2),]

# Clean up column names
colnames(data) = substring(colnames(data), 5)
colnames(data)[1] = 'giving_fice'

# Form Matrix
m = as.matrix(data[,2:ncol(data)])

m.w = melt(m)

# Remove NAs
m.w = m.w[!is.na(m.w$value),]

# Limit to those where flow > 10
m.w = m.w[m.w$value > 50,]

# Plot
#chordDiagram(m.w)


# Advanced Plot
chordDiagram(m.w, annotationTrack = "grid", preAllocateTracks = list(track.height = 0.1))
circos.trackPlotRegion(track.index = 1, panel.fun = function(x, y) {
  xlim = get.cell.meta.data("xlim")
  xplot = get.cell.meta.data("xplot")
  ylim = get.cell.meta.data("ylim")
  sector.name = get.cell.meta.data("sector.index")
  if(abs(xplot[2] - xplot[1]) < 10) {
    circos.text(mean(xlim), ylim[1], sector.name, facing = "clockwise",
                niceFacing = TRUE, adj = c(0, 0.5))
  } else {
    circos.text(mean(xlim), ylim[1], sector.name, facing = "inside",
                niceFacing = TRUE, adj = c(0.5, 0))
  }
}, bg.border = NA)