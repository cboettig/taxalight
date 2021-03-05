
#' Return the accepted taxonomic identifier, `acceptedNameUsageID` given a scientific name
#' 
#' @param name character vector of scientific names
#' @inheritParams tl
#' @return 
#' a vector of matching accepted identifiers.  Note that if the name
#' provided is considered to be a synonym by the provider, then the ID corresponds 
#' to the accepted name and not the synonym.  (i.e. `get_names(get_ids(synonym))`) 
#' will return the accepted name and not the synonym name.
#' 
#' @export
#' @examples
#' 
#' \dontshow{Sys.setenv(TAXALIGHT_HOME=tempfile())}
#' 
#' \donttest{ # slow initial import
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
#' get_ids(sp) 
#' }
#' 
#' \dontshow{Sys.unsetenv("TAXALIGHT_HOME")}
#' 
get_ids <- function(name,
                    provider = getOption("tl_default_provider", "itis"),
                    version = tl_latest_version(),
                    dir = tl_dir()
){
  
  ## tl resolver
  df <- tl(name, provider, version, dir)
  
  vapply(name, function(x){
    df <- df[df$scientificName == x, ]
    
    if(nrow(df) < 1) return(NA_character_)
    
    # Unambiguous: one acceptedNameUsageID per name
    if(nrow(df)==1) return(df$acceptedNameUsageID[1])
    
    ## Drop infraspecies when not perfect match
    df <- df[is.na(df$infraspecificEpithet),]
    
    ## If we resolve to a unique accepted ID, return that
    ids <- unique(df$acceptedNameUsageID)
    if(length(ids)==1){ 
      return(ids)
    } else {
      warning(paste0("  Found ", bb(length(ids)), " possible identifiers for ", 
                     ibr(x),
                     ".\n  Returning ", bb('NA'), ". Try ",
                     bb(paste0("tl('", x, "', '", provider,"')")),
                     " to resolve manually.\n"),
              call. = FALSE)
      return(NA_character_)
    }
  }, 
  character(1L))
}

ibr <- function(...){
  if(!requireNamespace("crayon", quietly = TRUE)) return(paste(...))
  crayon::italic(crayon::bold(crayon::red(...)))
}
bb <- function(...){
  if(!requireNamespace("crayon", quietly = TRUE)) return(paste(...))
  crayon::bold(crayon::blue(...))
}
