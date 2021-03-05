

#' taxalight data directory
#' 
#' taxalight stores data for persistent access in the directory given by
#' tl_dir() by default.  All functions can override this choice by passing
#' an alternative path to the `dir` argument, or configure the location 
#' system-wide by setting the environmental variable `TAXALIGHT_HOME`,
#' eg. in their `.Renviron` file, see [Sys.setenv()].  If unset, the default
#' location is the default for the operating system, as provided by the 
#' core R function [tools::R_user_dir()].  Users can manually purge the data
#' storage at any time by deleting this directory.
#' 
#' @export
#' 
#' @examples 
#' tl_dir()
#' 
tl_dir <- function() { 
  Sys.getenv("TAXALIGHT_HOME",
             tools::R_user_dir("taxalight"))
}
