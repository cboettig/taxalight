
#' taxalight query: rapidly look up scientific names from a local database
#' 
#' @param x character vector of either scientific names or 
#'   taxonomic identifiers (with prefix).  Can mix and match too.
#' @param provider Abbreviation for a known naming provider. 
#'   Provider data should first be imported with `[tl_create]`.
#'   Note: setting provider to `"itis_test"` is for testing purposes only,
#'   use `"itis"` for the full ITIS data.  See details
#' @param version version of the authority to use (e.g. four-digit year)
#' @param dir storage location for the LMDB databases
#' @details 
#'  Naming providers currently recognized by `taxalight` are:
#'  - `itis`: Integrated Taxonomic Information System, <https://www.itis.gov/>
#'  - `ncbi`:  National Center for Biotechnology Information,
#'  <https://www.ncbi.nlm.nih.gov/taxonomy>
#'  - `col`: Catalogue of Life, <http://www.catalogueoflife.org/>
#'  - `gbif`: Global Biodiversity Information Facility, <https://www.gbif.org/>
#'  - `ott`: OpenTree Taxonomy: <https://github.com/OpenTreeOfLife/reference-taxonomy>
#'  - `itis_test`: a small subset of ITIS, cached locally for testing purposes only.
#'  
#' The default provider is `itis`, which can be reconfigured by setting
#' `tl_default_provider` in `[options]`.
#' 
#' @export
#' @return a data.frame in Darwin Core format with rows matching the 
#' acceptedNameUsageID or scientificName requested.  
#' @seealso [tl_create]
#' 
#' @examples
#' 
#' \dontshow{Sys.setenv(TAXALIGHT_HOME=tempfile())}
#' 
#' \donttest{ # slow initial import
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
#' id <- c("ITIS:180092", "ITIS:179913")
#' 
#' ## example uses "itis_test" provider for illustration only:
#' tl(sp, "itis_test")
#' tl(id, "itis_test")
#'
#' }
#' \dontshow{Sys.unsetenv("TAXALIGHT_HOME")}
#'
tl <- function(x,
               provider = getOption("tl_default_provider", "itis"),
               version = tl_latest_version(),
               dir = tl_dir()){

  path <- lmdb_path(provider, version, dir)
  if(!file.exists(path)){
    tl_create(provider = provider, version = version, dir = dir)
  }

  db <- lmdb_init(path)
  
  ## dbs may not all use same columns in same order. enforce!
  col.names <- dwc_columns()
  lmdb_read(db, x, col.names, colClasses = "character")
  
}
