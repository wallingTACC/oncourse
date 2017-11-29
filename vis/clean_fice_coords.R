library(data.table)


setwd("/home/walling/dev/git/oncourse/vis")

lines = readLines("data/fice_lat_long.txt")

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