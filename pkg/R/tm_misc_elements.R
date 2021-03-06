#' Small multiples
#' 
#' Creates a \code{\link{tmap-element}} that specifies facets (small multiples). Small multiples can be created in two ways: 1) by specifying the \code{by} argument with one or two variable names, by which the data is grouped, 2) by specifying multiple variable names in any of the aesthetic argument of the layer functions (for instance, the argument \code{col} in \code{\link{tm_fill}}). This function further specifies the facets, for instance number of rows and columns, and whether the coordinate and scales are fixed or free (i.e. independent of each other).
#' 
#' @param by data variable name by which the data is split, or a vector of two variable names to split the data by two variables (where the first is used for the rows and the second for the columns).
#' @param ncol number of columns of the small multiples grid. Not applicable if \code{by} contains two variable names.
#' @param nrow number of rows of the small multiples grid. Not applicable if \code{by} contains two variable names.
#' @param free.coords logical. If the \code{by} argument is specified, should each map has its own coordinate ranges?
#' @param drop.units logical. If the \code{by} argument is specified, should non-selected spatial units be dropped? If \code{FALSE}, they are plotted where mapped aesthetics are regared as missing values. By default, \code{TRUE} if \code{free.coords=TRUE}. Not applicable for raster shapes.
#' @param drop.empty.facets logical. If the \code{by} argument is specified, should empty facets be dropped? Empty facets occur when the \code{by}-variable contains unused levels. When \code{TRUE} and two \code{by}-variables are specified, empty rows and colums are dropped.
#' @param showNA If the \code{by} argument is specified, should missing values of the \code{by}-variable be shown in a facet? If two \code{by}-variables are specified, should missing values be shown in an additional row and column? If \code{NA}, missing values only are shown if they exist. Similar to the \code{useNA} argument of \code{\link[base:table]{table}}, where \code{TRUE}, \code{FALSE}, and \code{NA} correspond to \code{"always"}, \code{"no"}, and \code{"ifany"} respectively.
#' @param textNA text used for facets of missing values.
#' @param free.scales logical. Should all scales of the plotted data variables be free, i.e. independent of each other? Possible data variables are color from \code{\link{tm_fill}}, color and size from \code{\link{tm_bubbles}} and line color from \code{\link{tm_lines}}.
#' @param free.scales.fill logical. Should the color scale for the choropleth be free?
#' @param free.scales.bubble.size logical. Should the bubble size scale for the bubble map be free?
#' @param free.scales.bubble.col logical. Should the color scale for the bubble map be free?
#' @param free.scales.text.size logical. Should the text size scale be free?
#' @param free.scales.text.col logical. Should the text color scale be free?
#' @param free.scales.line.col Should the line color scale be free?
#' @param free.scales.line.lwd Should the line width scale be free?
#' @param free.scales.raster Should the color scale for raster layers be free?
#' @param inside.original.bbox If \code{free.coords}, should the bounding box of each small multiple be inside the original bounding box?
#' @param scale.factor Number that determines how the elements (e.g. font sizes, bubble sizes, line widths) of the small multiples are scaled in relation to the scaling factor of the shapes. The elements are scaled to the \code{scale.factor}th root of the scaling factor of the shapes. So, for \code{scale.factor=1}, they are scaled proportional to the scaling of the shapes. Since elements, especially text, are often too small to read, a higher value is recommended. By default, \code{scale.factor=2}.
#' @param drop.shapes deprecated: renamed to \code{drop.units}
#' @export
#' @example ../examples/tm_facets.R
#' @seealso \href{../doc/tmap-nutshell.html}{\code{vignette("tmap-nutshell")}}
#' @return \code{\link{tmap-element}}
tm_facets <- function(by=NULL, ncol=NULL, nrow=NULL, 
					  free.coords=FALSE,
					  drop.units=free.coords,
					  drop.empty.facets=TRUE,
					  showNA=NA,
					  textNA="Missing",
					  free.scales=is.null(by),
					  free.scales.fill=free.scales,
					  free.scales.bubble.size=free.scales,
					  free.scales.bubble.col=free.scales,
					  free.scales.text.size=free.scales,
					  free.scales.text.col=free.scales,
					  free.scales.line.col=free.scales,
					  free.scales.line.lwd=free.scales,
					  free.scales.raster=free.scales,
					  inside.original.bbox=FALSE,
					  scale.factor=2,
					  drop.shapes=drop.units) {
	calls <- names(match.call(expand.dots = TRUE)[-1])
	if ("drop.shapes" %in% calls) warning("The argument drop.shapes has been renamed to drop.units, and is therefore deprecated", call.=FALSE)
	if ("free.scales" %in% calls) calls <- union(calls, c("free.scales.fill", "free.scales.bubble.size", "free.scales.bubble.col", "free.scales.line.col", "free.scales.line.lwd"))
	g <- list(tm_facets=c(as.list(environment()), list(call=calls)))
	class(g) <- "tmap"
	#attr(g, "call") <- names(match.call(expand.dots = TRUE)[-1])
	#g$call <- names(match.call(expand.dots = TRUE)[-1])
	g
}

#' Coordinate grid lines
#' 
#' Creates a \code{\link{tmap-element}} that draws coordinate grid lines. It serves as a layer that can be drawn anywhere between other layers. By default the coordinate system of the (master) shape object is used, which results in horizontal and vertical lines. Alternatively, grid lines can be reprojected, for instance to latitude longitude coordinates, and hence be curved.
#' 
#' @param x x coordinates for vertical grid lines. If \code{NA}, it is specified with a pretty scale and \code{n.x}.
#' @param y y coordinates for horizontal grid lines. If \code{NA}, it is specified with a pretty scale and \code{n.y}.
#' @param n.x prefered number of grid lines for the x axis.
#' @param n.y prefered number of grid lines for the y axis.
#' @param projection projection character. If specified, the grid lines are projected accordingly. See \code{\link{set_projection}} for projection details. Many world maps are projected, but still have latitude longitude (\code{"longlat"}) grid lines.
#' @param col color of the grid lines.
#' @param lwd line width of the grid lines
#' @param alpha alpha transparency of the grid lines. Number between 0 and 1. By default, the alpha transparency of \code{col} is taken. 
#' @param labels.size font size of the tick labels
#' @param labels.col font color of the tick labels
#' @param labels.inside.frame Show labels inside the frame?
#' @export
tm_grid <- function(x=NA,
					y=NA,
					n.x=NA,
					n.y=NA,
					projection=NA,
					col=NA,
					lwd=1,
					alpha=NA,
					labels.size=.6,
					labels.col=NA,
					labels.inside.frame=TRUE) {
	g <- list(tm_grid=as.list(environment()))
	names(g$tm_grid) <- paste("grid", names(g$tm_grid), sep=".")
	class(g) <- "tmap"
	attr(g, "call") <- names(match.call(expand.dots = TRUE)[-1])
	g
}

#' Credits text
#' 
#' Creates a text annotation that could be used for credits or acknowledgements.
#' 
#' @param text text. Multiple lines can be created with the line break symbol \code{"\\n"}. Facets can have different texts: in that case a vector of characters is required. Use \code{""} to omit the credits for specific facets.
#' @param size relative text size
#' @param col color of the text. By default equal to the argument \code{attr.color} of \code{\link{tm_layout}}.
#' @param alpha transparency number between 0 (totally transparent) and 1 (not transparent). By default, the alpha value of \code{col} is used (normally 1).
#' @param align horizontal alignment: \code{"left"} (default), \code{"center"}, or \code{"right"}. Only applicable if \code{text} contains multiple lines
#' @param bg.color background color for the text
#' @param bg.alpha Transparency number between 0 (totally transparent) and 1 (not transparent). By default, the alpha value of the \code{bg.color} is used (normally 1).
#' @param fontface font face of the text. By default, determined by the fontface argument of \code{\link{tm_layout}}.
#' @param fontfamily font family of the text. By default, determined by the fontfamily argument of \code{\link{tm_layout}}.
#' @param position position of the text. Vector of two values, specifing the x and y coordinates. Either this vector contains "left", "LEFT", "center", "right", or "RIGHT" for the first value and "top", "TOP", "center", "bottom", or "BOTTOM" for the second value, or this vector contains two numeric values between 0 and 1 that specifies the x and y value of the center of the text. The uppercase values correspond to the position without margins (so tighter to the frame). The default value is controlled by the argument \code{"attr.position"} of \code{\link{tm_layout}}.
#' @export
#' @example ../examples/tm_credits.R
tm_credits <- function(text,
					   size=.7,
					   col=NA,
					   alpha=NA,
					   align="left",
					   bg.color=NA,
					   bg.alpha=NA,
					   fontface=NA, fontfamily=NA,
					   position=NA) {
	g <- list(tm_credits=as.list(environment()))
	names(g$tm_credits) <- paste("credits", names(g$tm_credits), sep=".")
	class(g) <- "tmap"
	attr(g, "call") <- names(match.call(expand.dots = TRUE)[-1])
	g
}


#' Scale bar
#' 
#' Creates a scale bar. By default, the coordinate units are assumed to be meters, and the map units in kilometers. This can be changed in \code{\link{tm_shape}}.
#' 
#' @param breaks breaks of the scale bar. If not specified, breaks will be automatically be chosen given the prefered \code{width} of the scale bar.
#' @param width (prefered) width of the scale bar. Only applicable when \code{breaks=N ULL}
#' @param size relative text size (which is upperbound by the available label width)
#' @param text.color color of the text. By default equal to the argument \code{attr.color} of \code{\link{tm_layout}}.
#' @param color.dark color of the dark parts of the scale bar, typically (and by default) black.
#' @param color.light color of the light parts of the scale bar, typically (and by default) white.
#' @param lwd line width of the scale bar
#' @param position position of the text. Vector of two values, specifing the x and y coordinates. Either this vector contains "left", "LEFT", "center", "right", or "RIGHT" for the first value and "top", "TOP", "center", "bottom", or "BOTTOM" for the second value, or this vector contains two numeric values between 0 and 1 that specifies the x and y value of the left bottom corner of the scale bar. The uppercase values correspond to the position without margins (so tighter to the frame). The default value is controlled by the argument \code{"attr.position"} of \code{\link{tm_layout}}.
#' @export
#' @example ../examples/tm_scale_bar.R
tm_scale_bar <- function(breaks=NULL,
						 width=.25, 
						 size=.5,
						 text.color=NA,
						 color.dark="black", 
						 color.light="white",
						 lwd=1,
						 position=NA) {
	g <- list(tm_scale_bar=as.list(environment()))
	names(g$tm_scale_bar) <- paste("scale", names(g$tm_scale_bar), sep=".")
	class(g) <- "tmap"
	attr(g, "call") <- names(match.call(expand.dots = TRUE)[-1])
	g
}

#' Map compass
#' 
#' Creates a map compass.
#' 
#' @param north north direction in degrees: 0 means up, 90 right, etc.
#' @param type compass type, one of: \code{"arrow"}, \code{"4star"}, \code{"8star"}, \code{"radar"}, \code{"rose"}. The default is controlled by \code{\link{tm_layout}} (which uses \code{"arrow"} for the default style)
#' @param fontsize relative font size
#' @param size size of the compass in number of text lines. The default values depend on the \code{type}: for \code{"arrow"} it is 2, for \code{"4star"} and \code{"8star"} it is 4, and for \code{"radar"} and \code{"rose"} it is 6.
#' @param show.labels number that specifies which labels are shown: 0 means no labels, 1 (default) means only north, 2 means all four cardinal directions, and 3 means the four cardinal directions and the four intercardinal directions (e.g. north-east).
#' @param cardinal.directions labels that are used for the cardinal directions north, east, south, and west.
#' @param text.color color of the text. By default equal to the argument \code{attr.color} of \code{\link{tm_layout}}.
#' @param color.dark color of the dark parts of the compass, typically (and by default) black.
#' @param color.light color of the light parts of the compass, typically (and by default) white.
#' @param lwd line width of the compass
#' @param position position of the text. Vector of two values, specifing the x and y coordinates. Either this vector contains "left", "LEFT", "center", "right", or "RIGHT" for the first value and "top", "TOP", "center", "bottom", or "BOTTOM" for the second value, or this vector contains two numeric values between 0 and 1 that specifies the x and y value of the left bottom corner of the compass. The uppercase values correspond to the position without margins (so tighter to the frame). The default value is controlled by the argument \code{"attr.position"} of \code{\link{tm_layout}}.
#' @export
#' @example ../examples/tm_compass.R
tm_compass <- function(north=0, 
					   type=NA, 
					   fontsize=.8, 
					   size=NA,
					   show.labels=1, 
					   cardinal.directions=c("N", "E", "S", "W"), 
					   text.color=NA,
					   color.dark=NA, 
					   color.light=NA,
					   lwd=1,
					   position=NA) {
	g <- list(tm_compass=as.list(environment()))
	names(g$tm_compass) <- paste("compass", names(g$tm_compass), sep=".")
	class(g) <- "tmap"
	attr(g, "call") <- names(match.call(expand.dots = TRUE)[-1])
	g
}




#' Stacking of tmap elements
#' 
#' The plus operator allows you to stack \code{\link{tmap-element}s}, and groups of \code{\link{tmap-element}s}.
#' 
#' @param e1 first \code{\link{tmap-element}}
#' @param e2 second \code{\link{tmap-element}}
#' @seealso \code{\link{tmap-element}} and \href{../doc/tmap-nutshell.html}{\code{vignette("tmap-nutshell")}}
#' @export
"+.tmap" <- function(e1, e2) {
	g <- c(e1,e2)
	class(g) <- "tmap"
	g
}
