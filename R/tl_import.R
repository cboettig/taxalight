
## make contentid & jsonlite optional and otherwise cache a copy of the current prov table?
## Would need to fall back on download.file() then


#' Import taxonomic database tables
#' 
#' Downloads the requested taxonomic data tables and return a local path
#' to the data in `tsv.gz` format.  Downloads are cached and identified by
#' content hash so that `tl_import` will not attempt to download the
#' same file multiple times.
#' `tl_import` parses a PROV record to determine the correct version to download.
#' If offline, `tl_import` will attempt to resolve against it's own cache.
#' @inheritParams tl
#' @param schema schema to import from
#' @param prov Address (URL) to provenance record
#' 
#' @export
#' @importFrom contentid resolve
tl_import <- function(provider = getOption("tl_default_provider", "itis"),
                      schema = c("dwc", "common"),
                      version = tl_latest_version(),
                      prov = paste0("https://raw.githubusercontent.com/",
                                  "boettiger-lab/taxadb-cache/master/prov.json")){
  
  ## For unit tests / examples only
  if(provider == "itis_test")
    return(system.file("extdata", "itis_test.tsv.gz", package = "taxalight"))
  
  
  keys <- unlist(lapply(schema, paste, provider, version, sep="-"))
  
  prov <- parse_prov(prov)
  dict <- prov$id
  names(dict) <- prov$key
  
  ids <- as.character(na_omit(dict[keys]))
  
  ## This will resolve the content-based identifier for the data to an appropriate source,
  ## validate that the data matches the checksum given in the identifier, 
  ## and cache a local copy.  If the a local copy already matches the checksum,
  ## this will avoid downloading at all
  paths <- vapply(ids, contentid::resolve, "", store=TRUE)
  paths
}



na_omit <- function(x) x[!is.na(x)]


## data-raw me?
## export me? 

## Allow soft dependency
## @importFrom jsonlite read_json toJSON fromJSON

parse_prov <- function(url =  
    paste0("https://raw.githubusercontent.com/",
           "boettiger-lab/taxadb-cache/master/prov.json")){
  
  ## Meh, already imported by httr
  read_json <- getExportedValue("jsonlite", "read_json")
  toJSON <- getExportedValue("jsonlite", "toJSON")
  fromJSON <- getExportedValue("jsonlite", "fromJSON")
  
  cache <- system.file("extdata", "prov.json", package = "taxalight")
  
  prov <- tryCatch(read_json(url),
                   error = function(e) read_json(cache),
                   finally = read_json(cache)
  )
  graph <- toJSON(prov$`@graph`, auto_unbox = TRUE)
  df <- fromJSON(graph, simplifyVector = TRUE)
  
  outputs <- df[df$description == "output data",
                c("id", "title", "wasGeneratedAtTime", "compressFormat")]
  
  tmp <- vapply(outputs$wasGeneratedAtTime, `[[`, "", 1)
  outputs$wasGeneratedAtTime <- as.Date(tmp)
  outputs$version <- format(outputs$wasGeneratedAtTime, "%Y")
  outputs$key <- gsub("\\.tsv\\.gz", "", outputs$title)
  outputs$key <- gsub("\\.tsv\\.bz2", "", outputs$title)
  outputs$key <- gsub("_", "-", outputs$key)
  outputs$key <- paste(outputs$key, outputs$version, sep="-")
  outputs
}


tl_latest_version <- function(){
  prov <- parse_prov() 
  max(prov$version)
}