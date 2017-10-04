library(data.table)
library(chorddiag)

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

# Need a square matrix, so add columns with 'NA' for receiving fices missing in giving
giving_fices = unname(unlist(data[,1]))
receiving_fices=unname(colnames(data)[2:ncol(data)])

missing_receivers = giving_fices[which(!(giving_fices %in% receiving_fices))]

for(missing in missing_receivers) {
  m = cbind(m, missing=NA)
}

receiving_fices = c(receiving_fices, missing_receivers)

colnames(m) = receiving_fices

dimnames(m) <- list(giving = unname(giving_fices),
                    receiving = unname(receiving_fices))

# Order matrix by columns
m <- m[, order(colnames(m))]

# Set NA to 0
m[is.na(m)] <- 0

# Chord Diagram
#groupColors <- c("#000000", "#FFDD89", "#957244", "#F26223")
chorddiag(m) #, groupnamePadding = 20)


