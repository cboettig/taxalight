#' Provenance information for taxalight data sources
#' 
#' `tl_provenance` parses a JSON-LD file describing the data provenance between
#' the original source data and standardized tables imported by `taxalight` and
#' `taxadb` R packages.  The JSON-LD markup is specified using the DCAT2 and 
#' PROV namespaces, which is parsed and returned as a simple data.frame structure.  
#' 
#' All content (source data, scripts, and processed tables) are referenced by 
#' content-based identifiers (see [contentid::content_id()]), which provide automatic
#' caching of downloads and cryptographic certainty that a version has not been altered.
#' Rather than list a single download URL as the access point, content identifiers
#' can be resolves (see [contentid::resolve()]) to any of multiple sources which 
#' provide the identical content.  This makes them more robust to link rot, much
#' like a DOI. 
#' 
#' @param url The location of the most recent provenance record.  Leave as default.
#' @return A data frame summarizing the available processed data, along with
#' identifiers that can be resolved by [contentid::resolve()]. 
#' @noRd
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
