# world choropleth/bubble map of the world
data(World, metro)
metro$growth <- (metro$pop2020 - metro$pop2010) / (metro$pop2010 * 10) * 100

map1 <- tm_shape(metro) +
	tm_bubbles("pop2010", col = "growth", 
		border.col = "black", border.alpha = .5, 
		style="fixed", breaks=c(-Inf, seq(0, 6, by=2), Inf),
		palette="-RdYlBu", contrast=1, 
		title.size="Metro population", 
		title.col="Growth rate (%)", id="name") + 
	tm_legend(outside=TRUE)

current.mode <- tmap_mode("plot")

# plot map
map1

# view map with default view options
tmap_mode("view")
map1

# view map with changed view options
map1 + tm_view(alpha = 1, popup.all.data = TRUE, basemaps = "Stamen.Watercolor")

# restore current mode
tmap_mode(current.mode)
