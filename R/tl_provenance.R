
tl_provenance <- function(url =
                            paste0("https://raw.githubusercontent.com/",
                                   "boettiger-lab/taxadb-cache/master/prov.json"
                                   )
                          ){
  
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
  outputs$series <- gsub("\\.tsv\\.gz", "", outputs$title)
  outputs$series <- gsub("\\.tsv\\.bz2", "", outputs$series)
  outputs$key <- paste(outputs$version, outputs$series, sep="_")
  outputs
}