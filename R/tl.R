
#' taxalight query: rapidly look up scientific names from a local database
#' 
#' @param x character vector of either scientific names or 
#'   taxonomic identifiers (with prefix).  Can mix and match too.
#' @param provider Abbreviation for a known naming provider. 
#'   Provider data should first be imported with `[tl_create]`.
#' @param version version of the authority to use (e.g. four-digit year)
#' @param dir storage location for the LMDB databases
#' @return a data.frame in Darwin Core format with rows matching the 
#' acceptedNameUsageID or scientificName requested.  
#' @seealso [tl_create]
#' 
#' @examples
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
#' id <- c("ITIS:180092", "ITIS:179913")
#' 
#' tl(sp)
#' tl(id)
tl <- function(x,
               provider = getOption("taxadb_default_provider", "itis"),
               version = latest_version(),
               dir = tl_dir()){

  path <- lmdb_path(provider, version, dir)
  
  ## either assert path exists or call tl_create?
  
  db <- lmdb_init(path)
  
  ## dbs may not all use same columns in same order. enforce!
  col.names <- dwc_columns()
  lmdb_read(db, x, col.names, colClasses = "character")
  
}

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
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
#' get_ids(sp) 
get_ids <- function(name,
                   provider = getOption("taxadb_default_provider", "itis"),
                   version = latest_version(),
                   dir = tl_dir()
){
  
  df <- tl(name, provider, version, dir)
  df$acceptedNameUsageID
  
}


#' Return `scientificName` names given taxonomic identifiers
#' 
#' @param id a character vector of taxonomic identifiers, including provider prefix
#' @inheritParams tl
#' @return 
#' a vector of matching scientific names
#' 
#' @export
#' @examples
#' get_names(c("ITIS:180092", "ITIS:179913"))
#' 
get_names <- function(id,
                   provider = getOption("taxadb_default_provider", "itis"),
                   version = latest_version(),
                   dir = tl_dir()
){
  
  df <- tl(id, provider, version, dir)
  df$scientificName
  
}
