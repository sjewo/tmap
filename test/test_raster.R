library(raster)
library(sp)

data(World, land)


tmap_mode("plot")
tmap_mode("view")
repr <- FALSE
repr <- TRUE


## SpatialGridDF
tm_shape(land) +
	tm_raster("cover_cls") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()

tm_shape(land) +
	tm_raster("trees") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()


## RasterLayer
library(raster)

rl <- raster(land, layer=2)
tm_shape(rl) +
	tm_raster("cover_cls") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()

rl2 <- raster(land, layer=3)
tm_shape(rl2) +
	tm_raster("trees") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()


## Stack
rs <- stack(land)
tm_shape(rs) +
	tm_raster("cover_cls") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()

tm_shape(rs) +
	tm_raster("trees") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()


## Brick
rb <- brick(land)
tm_shape(rb) +
	tm_raster("cover_cls") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()

tm_shape(rb) +
	tm_raster("trees") +
	tm_shape(World, is.master = repr) +
	tm_borders() +
	tm_style_white()


## File1 (tile with elevation data)
rt <- raster("e:/data/elevation/dataNL/tif/i69cn2.tif")
qtm(rt)

## OSM tile
m <- read_osm(bb("Maastricht, Netherlands"))
qtm(m)

tm_shape(m, projection="eck4") +
	tm_raster()



m <- read_osm(bb("Maastricht, Netherlands"))
qtm(m)

tm_shape(m, projection="eck4") +
	tm_raster()


r3 <- brick("e:/pictures/2013-10 USA/jpg/desert.tif")

r3 <- set_projection(r3, current.projection = "rd")
qtm(r3)

r4 <- raster("sx99.tif")
r4 <- set_projection(r4, current.projection = "rd")
qtm(r4)

## performance
Rprof(tmp <- tempfile())
qtm(r4)
Rprof()
summaryRprof(tmp)
unlink(tmp)


## set_projection
land2 <- set_projection(land, projection="eck4")
qtm(land, raster="cover")
qtm(land2, raster="cover_cover")

rlB <- set_projection(rl, projection="eck4")
qtm(rl, raster="cover_cls")
qtm(rlB, raster="cover_cls")

rl2B <- set_projection(rl2, projection="eck4")
qtm(rl2, raster="trees")
qtm(rl2B, raster="trees")


rs2 <- set_projection(rs, projection="eck4")
qtm(rs, raster="trees")
qtm(rs2, raster="trees")

rb2 <- set_projection(rb, projection="eck4")
qtm(rb, raster="trees")
qtm(rb2, raster="trees")
