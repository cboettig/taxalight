

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
#' 
#' \dontshow{Sys.setenv(TAXALIGHT_HOME=tempfile())}
#' tl_create("itis_test")
#' \dontshow{Sys.unsetenv("TAXALIGHT_HOME")}
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

  ## Write taxonID as a key.  Not unique in DBs that give IDs to synonyms (i.e. ITIS)
  ## acceptedNameUsageID is not unique to any DB with synonyms: all synonyms share the same accepted ID
  ## all acceptedNameUsageIDs are taxonIDs, but in some DBs (ITIS) some taxonIDs are not accepted
  lmdb_serialize(db, txt, df1$taxonID)

  ## Also write scientificName as a key. Note: not unique,
  ## a name can be a synonym to multiple IDs, or both a syn and accepted name
  lmdb_serialize(db, txt, paste(df1$genus, df1$specificEpithet))

  ## includes synonyms and non-synonyms
  lmdb_serialize(db, txt, df1$scientificName)
  
  
  ## Lastly, write vernacularName as a key. POSSIBLY VERY SILLY!
  lmdb_serialize(db, txt, df1$vernacularName)
  
  invisible(db)
}




tl_dir <- function() { 
  Sys.getenv("TAXALIGHT_HOME",
  tools::R_user_dir("taxalight"))
}

TAXALIGHT_COLUMNS <- c("taxonID", "scientificName", "acceptedNameUsageID",
           "taxonomicStatus", "taxonRank", "kingdom", "phylum",
           "class", "order", "family", "genus", "specificEpithet",
           "infraspecificEpithet", "vernacularName")

dwc_columns <- function(available_names = TAXALIGHT_COLUMNS) {
  known <- TAXALIGHT_COLUMNS
  known[known %in% available_names]
}
