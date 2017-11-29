library(data.table)
library(sqldf)

setwd("/home/walling/dev/git/oncourse/transfers-dashboard/")
fices = read.csv("FICE-IPEDS_Crosswalk.csv", colClasses=c('character')) # Do not convert fice to int

lines = readLines("fice_lat_long.txt")

data.list = lapply(lines, function(d) {
  print(d)
  # Example:
  # SCHREINER COLLEGE 003610 KERR 29 59 99 05
  # SN ANTO DIST JC ALL CAM 009162 29 28 98 29
  
  splits = strsplit(d, split = ' ')[[1]]
  nsplits = length(splits)
  
  # Last 4 solumns are lat/long
  lat = as.numeric(paste0(splits[nsplits-3], '.', splits[nsplits-2]))
  long = as.numeric(paste0(splits[nsplits-1], '.', splits[nsplits]))
  
  fice = splits[min(grep('0', splits))]
  
  return(data.table(fice=fice, lat=lat, long=long))
})

data.coords = rbindlist(data.list)

data.coords = data.coords[complete.cases(data.coords)]

### Transfer data
format_transfers <- function() {
  
  data = fread("fice_transfers.csv", na.strings = '#NULL!', colClass=c('character', rep('numeric', 113)))
  
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
  
  return(m)
}

nodes = data.coords

m = format_transfers()
edges = cbind(expand.grid(dimnames(m)), value = as.vector(m))

data =  sqldf("select e.giving, fa.Institution as giving_name, a.lat as a_lat, -1*a.long as a_long, 
              e.receiving, fb.Institution as receiving_name,  b.lat as b_lat, -1*b.long as b_long, e.value
              from edges e
              join nodes a on e.giving=a.fice
              join fices fa on fa.FICE=a.fice
              join nodes b on e.receiving=b.fice
              join fices fb on fb.FICE=b.fice")

save(data, file="data.Rdata")