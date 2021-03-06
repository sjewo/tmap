process_layers <- function(g, z, gt, gf, allow.small.mult) {
	if (dupl <- anyDuplicated(names(g))) {
		warning("One tm layer group has duplicated layer types, which are omitted. To draw multiple layers of the same type, use multiple layer groups (i.e. specify tm_shape prior to each of them).", call. = FALSE)
		g <- g[-dupl]	
	} 
	
	type <- g$tm_shape$type
	if (type=="polygons" && "tm_lines" %in% names(g)) {
		stop(g$tm_shape$shp_name, " consists of polygons, so it cannot accept tm_lines.", call. = FALSE)
	} else if (type=="polygons" && "tm_raster" %in% names(g)) {
		stop(g$tm_shape$shp_name, " consists of polygons, so it cannot accept tm_raster.", call. = FALSE)
	} else if (type=="raster" && any(c("tm_fill", "tm_borders") %in% names(g))) {
		stop(g$tm_shape$shp_name, " is a raster, so it cannot accept tm_fill/tm_borders/tm_polygons.", call. = FALSE)
	} else if (type=="raster" && "tm_lines" %in% names(g)) {
		stop(g$tm_shape$shp_name, " is a raster, so it cannot accept tm_lines.", call. = FALSE)
	} else if (type=="raster" && "tm_bubbles" %in% names(g)) {
		stop(g$tm_shape$shp_name, " is a raster, so it cannot accept tm_bubbles/tm_dots.", call. = FALSE)
	} else if (type=="points" && "tm_lines" %in% names(g)) {
		stop(g$tm_shape$shp_name, " consists of spatial points, so it cannot accept tm_lines.", call. = FALSE)
	} else if (type=="points" && "tm_raster" %in% names(g)) {
		stop(g$tm_shape$shp_name, " consists of spatial points, so it cannot accept tm_raster.", call. = FALSE)
	} else if (type=="points" && any(c("tm_fill", "tm_borders") %in% names(g))) {
		stop(g$tm_shape$shp_name, " consists of spatial points, so it cannot accept tm_fill/tm_borders/tm_polygons.", call. = FALSE)
	} else if (type=="lines" && any(c("tm_fill", "tm_borders") %in% names(g))) {
		stop(g$tm_shape$shp_name, " consists of spatial lines, so it cannot accept tm_fill/tm_borders/tm_polygons.", call. = FALSE)
	} else if (type=="lines" && "tm_raster" %in% names(g)) {
		stop(g$tm_shape$shp_name, " consists of spatial lines, so it cannot accept tm_raster.", call. = FALSE)
	}
	
	data <- g$tm_shape$data
	
	scale <- gt$scale
	if (g$tm_shape$by[1]=="") {
		data$GROUP_BY <- factor("_NA_")
		by <- NA
		ncol <- NA
		nrow <- NA
		panel.names <- NA
	} else {
		if (!all(g$tm_shape$by %in% names(data))) stop("Variable(s) \"", paste(setdiff(g$tm_shape$by, names(data)), collapse=", "), "\" not found in ", g$tm_shape$shp_name, call.=FALSE)
		
		d <- data[, g$tm_shape$by, drop=FALSE]
		d2 <- lapply(d, function(dcol) {
			showNA <- ifelse(is.na(gf$showNA), any(is.na(dcol)), gf$showNA)
			if (is.factor(dcol)) {
				lev <- if (gf$drop.empty.facets) levels(dcol)[table(dcol)>0] else levels(dcol)
				dcol <- as.character(dcol)
			} else {
				lev <- as.character(sort(unique(dcol)))
			}
			if (showNA) {
				lev <- c(lev, gf$textNA)
				dcol[is.na(dcol)] <- gf$textNA
			}
			factor(dcol, levels=lev)
		})
		if (length(g$tm_shape$by)==1) {
			data$GROUP_BY <- d2[[1]]
			by <- levels(data$GROUP_BY)
			ncol <- NA
			nrow <- NA
			panel.names <- by
		} else {
			by <- paste(rep(levels(d2[[1]]), each=nlevels(d2[[2]])),
						rep(levels(d2[[2]]), times=nlevels(d2[[1]])), sep="__")
			data$GROUP_BY <- factor(paste(d2[[1]], d2[[2]], sep="__"), levels = by)
			ncol <- nlevels(d2[[2]])
			nrow <- nlevels(d2[[1]])
			panel.names <- list(levels(d2[[1]]), levels(d2[[2]]))
		}
	}

	# determine plotting order 
	plot.order <- names(g)[names(g) %in% c("tm_fill", "tm_borders", "tm_text", "tm_bubbles", "tm_lines", "tm_raster")]
	plot.order[plot.order=="tm_borders"] <- "tm_fill"
	plot.order <- unique(plot.order)
	
	# border info
	gborders <- if (is.null(g$tm_borders)) {
		list(col=NULL, lwd=1, lty="blank", alpha=NA)
	} else g$tm_borders
	if (!is.null(gborders$col)) {
		if (is.na(gborders$col)) {
			gborders$col <- gt$aes.colors["borders"]
		}
	} else {
		gborders$col <- NA
	}
	gborders$col <- do.call("process_color", c(list(col=gborders$col, alpha=gborders$alpha), gt$pc))
	
# 	gborders$lwd <- gborders$lwd * scale
	
	
	# fill info
	if (is.null(g$tm_fil)) {
		gfill <- list(fill=NULL, xfill=NA, fill.legend.title=NA, fill.id=NA) 
	} else {
		gfill <- process_fill(data, g$tm_fill, gborders, gt, gf, z=z+which(plot.order=="tm_fill"), allow.small.mult=allow.small.mult)
	}
	# bubble info
	if (is.null(g$tm_bubbles)) {
		gbubble <- list(bubble.size=NULL, xsize=NA, xcol=NA, bubble.size.legend.title=NA, bubble.col.legend.title=NA, bubble.id=NA)
	} else {
		gbubble <- process_bubbles(data, g$tm_bubbles, gt, gf, z=z+which(plot.order=="tm_bubbles"), allow.small.mult=allow.small.mult)
	}

	# lines info
	if (is.null(g$tm_lines)) {
		glines <- list(line.lwd=NULL, xline=NA, xlinelwd=NA, line.col.legend.title=NA, line.lwd.legend.title=NA, line.id=NA) 
	} else {
		glines <- process_lines(data, g$tm_lines, gt, gf, z=z+which(plot.order=="tm_lines"), allow.small.mult=allow.small.mult)	
	} 

	# raster info
	if (is.null(g$tm_raster)) {
		graster <- list(raster=NULL, xraster=NA, raster.legend.title=NA) 
	} else {
		graster <- process_raster(data, g$tm_raster, gt, gf, z=z+which(plot.order=="tm_raster"), allow.small.mult=allow.small.mult)
	}	
	
	
	# text info
	if (is.null(g$tm_text)) {
		gtext <- list(text=NULL, xtext=NA, xtsize=NA, xtcol=NA, text.size.legend.title=NA, text.col.legend.title=NA)
	}  else {
		gtext <- process_text(data, g$tm_text, if (is.null(gfill$fill)) NA else gfill$fill, gt, gf, z=z+which(plot.order=="tm_text"), allow.small.mult=allow.small.mult)
	}

	any.legend <- any(!is.na(c(gfill$fill.legend.title, gbubble$bubble.size.legend.title, gbubble$bubble.col.legend.title, glines$line.col.legend.title, glines$line.lwd.legend.title, graster$raster.legend.title, gtext$text.size.legend.title, gtext$text.col.legend.title)))
	# 	glines$line.lwd.legend.title
	
	c(list(npol=nrow(data), varnames=list(by=by, fill=gfill$xfill, bubble.size=gbubble$xsize, bubble.col=gbubble$xcol, line.col=glines$xline, line.lwd=glines$xlinelwd, raster=graster$xraster, text.size=gtext$xtsize, text.col=gtext$xtcol), idnames=list(fill=gfill$fill.id, bubble=gbubble$bubble.id, line=glines$line.id, raster=graster$raster.id, text=gtext$text.id), data_by=data$GROUP_BY, nrow=nrow, ncol=ncol, panel.names=panel.names, plot.order=plot.order, any.legend=any.legend), gborders, gfill, glines, gbubble, gtext, graster)
}