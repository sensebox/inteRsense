#' Returns ImageBounds
#' 
#' @export
#' @import sp

imageBounds <- function(input){
  oSeM_df <- input
  
  coordinates(oSeM_df) =~longitude+latitude
  proj4string(oSeM_df)="+proj=longlat +datum=WGS84"
  project_df=spTransform(oSeM_df, CRS("+proj=longlat +datum=WGS84")) #projInfo(type="proj")
  
  bbox <- bbox(oSeM_df)
  list <- c(floor(bbox[1]), floor(bbox[2]), ceiling(bbox[3]), ceiling(bbox[4]))
  return(list)
}