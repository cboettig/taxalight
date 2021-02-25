
## make contentid & jsonlite optional and otherwise cache a copy of the current prov table?
## Would need to fall back on download.file() then


#' Import taxonomic database tables
#'
#' Downloads the requested taxonomic data tables and return a local path
#' to the data in `tsv.gz` format.  Downloads are cached and identified by
#' content hash so that `tl_import` will not attempt to download the
#' same file multiple times. 
#' `tl_import` parses a PROV record to determine the correct version to download.
#' If offline, `tl_import` will attempt to resolve against its own cached 
#' provenance record.
#' 
#' @inheritParams tl
#' @param schema schema to import from
#' @param prov Address (URL) to provenance record
#'
#' @details
#' `tl_import` parses a DCAT2/PROV-O record to determine the correct version
#'  to download. If offline, `tl_import` will attempt to resolve against
#'  it's own provenance cache. Users can also examine / parse the prov
#'  JSON-LD file directly to determine the provenance of the data products
#'  used.
#'
#'
#' @return path(s) to the downloaded files in the cache
#' @export
#' @importFrom contentid resolve
tl_import <- function(provider = getOption("tl_default_provider", "itis"),
                      schema = "dwc",
                      version = tl_latest_version(),
                      prov = paste0("https://raw.githubusercontent.com/",
                                    "boettiger-lab/taxadb-cache/master/prov.json")
){
  
  series <- unlist(lapply(schema, paste, provider, sep="_"))
  keys <- paste(version, series, sep="_")
  
  ## For unit tests / examples only
  if(provider == "itis_test"){
    testfile <- itis_test_data(version)
    return(testfile[keys])
  }
  
  prov <- tl_provenance(prov)
  dict <- prov$id
  names(dict) <- prov$key
  
  if(any(is.na(dict[keys]))){
    message(paste("could not find",
                  paste(keys[is.na(dict[keys])], collapse= ", "),
                  "\n  checking for older versions."))
    
    tmp <- prov[prov$series %in% series, ]
    keys <- tmp$key
    message(paste("  using", paste(keys, collapse= ", ")))
    dict <- tmp$id
    names(dict) <- tmp$key
    
  }
  
  ids <- as.character(na_omit(dict[keys]))
  tablenames <- names(na_omit(dict[keys]))
  
  ## This will resolve the content-based identifier for the data to an appropriate source,
  ## validate that the data matches the checksum given in the identifier,
  ## and cache a local copy.  If the a local copy already matches the checksum,
  ## this will avoid downloading at all
  paths <- vapply(ids, contentid::resolve, "", store=TRUE)
  names(paths) <- tablenames
  paths
}

itis_test_data <-function(version = tl_latest_version()){
  testfile <- system.file("extdata", "dwc_itis_test.tsv.gz",
                          package = "taxalight")
  names(testfile) <- paste0(version, "_dwc_itis_test")
  testfile
}






tl_latest_version <-
  function(url = paste0("https://raw.githubusercontent.com/",
                        "boettiger-lab/taxadb-cache/master/prov.json")){
    prov <- tl_provenance(url)
    max(prov$version)
    
  }


