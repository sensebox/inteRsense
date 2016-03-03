#' Returns the Bbox in form of an array of a given JSON
#' 
#' @export
#' @import sp
#' 
#' @param input An unnested JSON

imageBounds <- function(input){
  oSeM_df <- input
  
  coordinates(oSeM_df) =~longitude+latitude
  proj4string(oSeM_df)="+proj=longlat +datum=WGS84"
  project_df=spTransform(oSeM_df, CRS("+proj=longlat +datum=WGS84")) 

  
  bbox <- bbox(oSeM_df)
#   list <- c(c(floor(bbox[2]), floor(bbox[1])),  c(ceiling(bbox[4]), ceiling(bbox[3])))
  list <- c(c(bbox[2], bbox[1]),  c(bbox[4], bbox[3]))
  return(list)
}