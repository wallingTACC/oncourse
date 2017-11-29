library(maps)
library(igraph)
map("usa")
map.axes()
igraph:::igraph.Arrows(-120, 40, -90, 45, curve=0.3, sh.col="blue")
igraph:::igraph.Arrows(-100.5, 35.5, -110.5, 38.5, curve=0.5, sh.lwd=5, sh.col="orange")


edges = as.data.table(edges)
nodes = as.data.table(nodes)

library(sqldf)
data =  sqldf("select e.giving, a.lat as a_lat, -1*a.long as a_long, e.receiving, b.lat as b_lat, -1*b.long as b_long, e.value
              from edges e
              join nodes a on e.giving=a.fice
              join nodes b on e.receiving=b.fice
              order by value desc
              limit 10000")

#### Texas ####
library(mapdata)
library(ggplot2)
library(grid)

states <- map_data("state")

tx_df <- subset(states, region == "texas")
counties <- map_data("county")
tx_county <- subset(counties, region == "texas")

avg_value = mean(data$value)

# Base state map
ggplot(data = tx_df) + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "palegreen", color = "black") + 
  coord_fixed(1) + 
  geom_segment(aes(x=a_long, y=a_lat, xend=b_long, yend=b_lat, size=value, color=giving), data=data, arrow=arrow(length=unit(0.1,"cm"), ends='first', type='closed'))

# Add transfer lines
for(i in 1:nrow(data)) {
  print(i)
  trans = data[i,]
  map = map + geom_curve(aes(x=trans$a_long, y=trans$a_lat, xend=trans$b_long, yend=trans$b_lat, color='black', inherit.aes = T))
}

map

map + geom_curve(aes(x=trans$a_long, y=trans$a_lat, xend=trans$b_long, yend=trans$b_lat, color='black', inherit.aes = T))
map + geom_curve(aes(x=-96.24, y=35.1, xend=-95.15, yend=29.26, color='black', inherit.aes = T))
