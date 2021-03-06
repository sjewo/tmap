\dontrun{
data(World, metro, Europe)

m1 <- tm_shape(Europe) + 
	      tm_fill("yellow") + 
	      tm_borders() + 
	  tm_facets(by = "name", nrow=1,ncol=1) + 
      tm_layout(scale=2, outer.margins=0, asp=0)

animation_tmap(m1, filename="European countries.gif", width=1200, height=800, delay=100)

m2 <- tm_shape(World) +
          tm_polygons() +
      tm_shape(metro) + 
          tm_bubbles(paste0("pop", seq(1970, 2030, by=10)), 
              border.col = "black", border.alpha = .5) +
      tm_facets(free.scales.bubble.size = FALSE, nrow=1,ncol=1) + 
      tm_format_World(scale=2, outer.margins=0,asp=0)

animation_tmap(m2, filename="World population.gif", width=1200, height=550, delay=100)
}
