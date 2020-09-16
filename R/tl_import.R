
#' @importFrom contentid resolve
td_import <- function(provider = getOption("taxadb_default_provider", "itis"),
                      schema = c("dwc", "common"),
                      version = latest_version()){
  
  
  keys <- unlist(lapply(schema, paste, provider, version, sep="-"))
  
  prov <- parse_prov()
  dict <- prov$id
  names(dict) <- prov$key
  
  ids <- as.character(na.omit(dict[keys]))
  
  paths <- vapply(ids, contentid::resolve, "", store=TRUE)
  tsv_gz_ext(paths)
}



tsv_gz_ext <- function(paths){
  vapply(paths,
         function(x){
           file.rename(x, paste0(x, ".tsv.gz"))
           paste0(x, ".tsv.gz")
         }, "")
}



## data-raw me?
parse_prov <- function(url =  "https://raw.githubusercontent.com/boettiger-lab/taxadb-cache/master/prov.json"){
  prov <- jsonlite::read_json(url)
  graph <- jsonlite::toJSON(prov$`@graph`, auto_unbox = TRUE)
  df <- jsonlite::fromJSON(graph, simplifyVector = TRUE)
  
  outputs <- df[df$description == "output data",
                c("id", "title", "wasGeneratedAtTime", "compressFormat")]
  
  
  outputs$wasGeneratedAtTime <- as.POSIXct(outputs$wasGeneratedAtTime)
  outputs$version <- format(outputs$wasGeneratedAtTime, "%Y")
  outputs$key <- gsub("\\.tsv\\.gz", "", outputs$title)
  outputs$key <- gsub("_", "-", outputs$key)
  outputs$key <- paste(outputs$key, outputs$version, sep="-")
  outputs
}


