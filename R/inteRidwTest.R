#' Create a PNG which shows interpolated senseMap Data
#' 
#' @export
#' @import sp
#' @import gstat
#' @import rgeos
#' @import maptools

inteRidwTest <- function(input){
  ### JSON to data.frame ###
  oSeM_df <- input
  ### data.frame to spatialPointsDataFrame ###
  coordinates(oSeM_df) =~longitude+latitude
  ### adding CRS to the data ###
  proj4string(oSeM_df)="+proj=longlat +datum=WGS84"
  project_df=spTransform(oSeM_df, CRS("+proj=longlat +datum=WGS84")) 
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
  proj4string(grdSp)="+proj=longlat +datum=WGS84"
  grd_df=spTransform(grdSp, CRS("+proj=longlat +datum=WGS84")) 
  ### setting up basegrid for the png ###
  grdSp.union <- unionSpatialPolygons(grd_df, rep("x", length(slot(grd_df,"polygons"))))
  llGRD <- GE_SpatialGrid(grdSp.union)
  llGRD_in <- over(llGRD$SG, grdSp.union)
  llSGDF <- SpatialGridDataFrame(grid = slot(llGRD$SG,"grid"), proj4string = CRS(proj4string(llGRD$SG)), data = data.frame(in0 = llGRD_in))
  llSPix <- as(llSGDF, "SpatialPixelsDataFrame")
  ### IDW ###
  llSPix$pred <- idw(value ~ 1, oSeM_df, llSPix)$var1.pred
  return(llSPix$pred)
#   ### create the png ###
#   png(file = "idw.png", width = llGRD$width,height = llGRD$height, bg = "transparent")
#   par(mar = c(0, 0, 0, 0), xaxs = "i", yaxs = "i")
#   image(llSPix, "pred", col = bpy.colors(20, alpha=0.7))
#   dev.off()
}