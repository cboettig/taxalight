
## make contentid & jsonlite optional and otherwise cache a copy of the current prov table?
## Would need to fall back on download.file() then


#' @importFrom contentid resolve
tl_import <- function(provider = getOption("tl_default_provider", "itis"),
                      schema = c("dwc", "common"),
                      version = tl_latest_version()){
  
  ## For unit tests / examples only
  if(provider == "itis_test")
    return(system.file("extdata", "itis_test.tsv.gz", package = "taxalight"))
  
  
  keys <- unlist(lapply(schema, paste, provider, version, sep="-"))
  
  prov <- parse_prov()
  dict <- prov$id
  names(dict) <- prov$key
  
  ids <- as.character(na.omit(dict[keys]))
  
  ## This will resolve the content-based identifier for the data to an appropriate source,
  ## validate that the data matches the checksum given in the identifier, 
  ## and cache a local copy.  If the a local copy already matches the checksum,
  ## this will avoid downloading at all
  paths <- vapply(ids, contentid::resolve, "", store=TRUE)
  paths
}






## data-raw me?
## export me? 

## Allow soft dependency
## @importFrom jsonlite read_json toJSON fromJSON

parse_prov <- function(url =  "https://raw.githubusercontent.com/boettiger-lab/taxadb-cache/master/prov.json"){
  
  ## Meh, already imported by httr
  read_json <- getExportedValue("jsonlite", "read_json")
  toJSON <- getExportedValue("jsonlite", "toJSON")
  fromJSON <- getExportedValue("jsonlite", "fromJSON")
  
  
  prov <- read_json(url)
  graph <- toJSON(prov$`@graph`, auto_unbox = TRUE)
  df <- fromJSON(graph, simplifyVector = TRUE)
  
  outputs <- df[df$description == "output data",
                c("id", "title", "wasGeneratedAtTime", "compressFormat")]
  
  
  outputs$wasGeneratedAtTime <- as.POSIXct(outputs$wasGeneratedAtTime)
  outputs$version <- format(outputs$wasGeneratedAtTime, "%Y")
  outputs$key <- gsub("\\.tsv\\.gz", "", outputs$title)
  outputs$key <- gsub("_", "-", outputs$key)
  outputs$key <- paste(outputs$key, outputs$version, sep="-")
  outputs
}


tl_latest_version <- function(){
  prov <- parse_prov() 
  max(prov$version)
}