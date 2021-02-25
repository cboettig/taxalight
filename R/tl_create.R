

#' Create a Lightning Memory-Mapped Database (LMDB) for a given provider
#' 
#' Download raw data and store in a local LMDB database.  Importing
#' data is a time-consuming step that needs be run only once per
#' machine and will persist through sessions.
#' @inheritParams tl
#' @param lines number of lines to read in each chunk. 
#' @inherit tl details
#' @export
#' @examples
#' 
#' ## example uses "itis_test" for illustration only:
#' tl_create("itis_test")
#' 
#' 
tl_create <- function(provider = getOption("tl_default_provider", "itis"),
                      version = tl_latest_version(),
                      dir =  tl_dir(),
                      lines = 1e5L){
  
  schema <- "dwc" ## importer does not handle common names table yet
  db <- lmdb_init(lmdb_path(provider, version, dir))
  lambda <- function(chunk) lmdb_importer(chunk, db)
  
  paths <- tl_import(provider, schema, version)
  
  lapply(paths,
         process_chunks,
         lambda,
         lines = lines)
  
  invisible(db)
  
}

## Our basic strategy is to write the rows & columns that match
## into a single text string with "\t" delimiters for columns and 
## "\n" delimiters for rows, allowing the character vector to
## easily be transformed back into a table


lmdb_importer <- function(df, db){

  ## Enforce standard column selection & order
  df1 <- df[dwc_columns(names(df))]
    
  ## collapse columns with `\t`.  Is there a faster way?
  txt = do.call(function(...) paste(..., sep="\t"), df1)

  ## Write acceptedNameUsageID key (may not be unique due to synonyms)
  ## collapse groups  with `\n`.  base R, bitches
  ids <- tapply(txt, df1$acceptedNameUsageID, paste, collapse="\n")
  db$mput(key = names(ids), value = ids)
  
  ## Now write scientificName as a key.
  sci <- tapply(txt, df1$scientificName, paste, collapse="\n")
  db$mput(key = names(sci), value = sci)
  
  ## Write taxonID for any synonyms (should be unique)
  syn_ids <- !is.na(df1$taxonID) | (df1$taxonID != df1$acceptedNameUsageID)
  db$mput(key = df1$taxonID[syn_ids], value = txt[syn_ids])

  ## Lastly, write vernacularName as a key. POSSIBLY VERY SILLY!
  has_common <- !is.na(df1$vernacularName)
  if(any(has_common)){
    common <- tapply(txt[has_common], df1$vernacularName[has_common],
                     paste, collapse="\n")
    db$mput(key = names(common), value = common)
  }
  invisible(db)
}


lmdb_path <- function(provider =  getOption("tl_default_provider", "itis"),
                      version = tl_latest_version(),
                      dir = tl_dir() ){
  file.path(dir, provider, version)
}

#' @importFrom rappdirs user_data_dir
tl_dir <- function() { 
  Sys.getenv("TAXALIGHT_HOME",
  tools::R_user_dir("taxalight"))
}

dwc_columns <- function(available_names) {
  
  known <- c("taxonID", "scientificName", "acceptedNameUsageID",
    "taxonomicStatus", "taxonRank", "kingdom", "phylum",
    "class", "order", "family", "genus", "specificEpithet",
    "infraspecificEpithet", "vernacularName")
  known[known %in% available_names]
}
