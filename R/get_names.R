
#' Return `scientificName` names given taxonomic identifiers
#' 
#' @param id a character vector of taxonomic identifiers, including provider prefix
#' @inheritParams tl
#' @return 
#' a vector of matching scientific names
#' 
#' @export
#' @examples
#' \dontshow{Sys.setenv(TAXALIGHT_HOME=tempfile())}
#' \donttest{ # slow initial import
#' get_names(c("ITIS:180092", "ITIS:179913"), "itis_test") # uses test version
#' }
#' \dontshow{Sys.unsetenv("TAXALIGHT_HOME")}
#' 
get_names <- function(id,
                      provider = getOption("tl_default_provider", "itis"),
                      version = tl_latest_version(),
                      dir = tl_dir()
){
  
  df <- tl(id, provider, version, dir)
  if(nrow(df) < 1) return(NA_character_)
  
  df <- df[df$taxonomicStatus == "accepted", ]
  df$scientificName
  
}
