#' This function interpolates senseMap data using the IDW method.
#' 
#' 
#' @export
#' @import sp
#' @import rgdal
#' @import gstat
#' @import rgeos
#' @import maptools
#' 
#' @param input An unnested JSON

inteRtp <- function(input){ 
  library(sp)
  library(rgdal)
  library(gstat)
  library(rgeos)
  library(maptools)
  
  ### JSON to data.frame ###
  oSeM_df <- input
  ### data.frame to spatialPointsDataFrame ###
  coordinates(oSeM_df) =~longitude+latitude
  ### adding CRS to the data ###
  proj4string(oSeM_df)="+init=epsg:3857" 
  project_df=spTransform(oSeM_df, CRS("+init=epsg:3857"))
  ### creating a bounding box ###
  bbox <- bbox(oSeM_df)
  ### creating a grid based on the bbox ###
  x.range <- as.numeric(c(floor(bbox[1]), ceiling(bbox[3]))) # min/max longitude of the interpolation area
  y.range <- as.numeric(c(floor(bbox[2]), ceiling(bbox[4])))# min/max latitude of the interpolation area  
  grd <- expand.grid(x = seq(from = x.range[1], to = x.range[2], by = 0.1), y = seq(from = y.range[1], to = y.range[2], by = 0.1))
  coordinates(grd) <- ~x + y
  gridded(grd) <- TRUE
  grdSp <- as(grd, "SpatialPolygons")
  ### adding CRS to grid ###
  proj4string(grdSp)="+init=epsg:3857"
  grd_df=spTransform(grdSp, CRS("+init=epsg:3857")) 
  ### setting up basegrid for the png ###
  grdSp.union <- unionSpatialPolygons(grd_df, rep("x", length(slot(grd_df,"polygons"))))
  llGRD <- Sobj_SpatialGrid(grdSp.union)
  llGRD_in <- over(llGRD$SG, grdSp.union)
  llSGDF <- SpatialGridDataFrame(grid = slot(llGRD$SG,"grid"), proj4string = CRS(proj4string(llGRD$SG)), data = data.frame(in0 = llGRD_in))
  llSPix <- as(llSGDF, "SpatialPixelsDataFrame")
  ### IDW ###
  llSPix$pred <- idw(value ~ 1, oSeM_df, llSPix, nmax=1)$var1.pred
  ### create the png ###
  png(file = "idw.png", width = llGRD$width,height = llGRD$height, bg = "transparent")
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image(llSPix, "pred", col = bpy.colors(20, alpha=0.7))
  dev.off()
  png(file = "legend.png", width = 200, res = 250, bg = "transparent")
  par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
  image.plot(zlim=c(min(llSPix$pred),max(llSPix$pred)), nlevel=20 ,legend.only=TRUE, horizontal=FALSE, col = bpy.colors(20, alpha=0.7))
  dev.off()
}













