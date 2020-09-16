



tl_create <- function(provider = getOption("taxadb_default_provider", "itis"),
                      version = latest_version(),
                      dir =  taxalight_dir(),
                      ...){
  
  schema <- "dwc" ## importer does not handle common names table yet
  db <- lmdb_init(lmdb_path(provider, version, dir))
  lambda <- function(chunk) lmdb_importer(chunk, db)
  
  paths <- tl_import(provider, schema, version)
  
  lapply(paths,
         process_chunks,
         lambda)
  
}

## Our basic strategy is to write the rows & columns that match
## into a single text string with "\t" delimiters for columns and 
## "\n" delimiters for rows, allowing the character vector to
## easily be transformed back into a table


lmdb_importer <- function(df, db){

  ## Enforce standard column ordering and choice!
  df1 <- df[dwc_columns()]
    
  ## collapse columns with `\t`.  Is there a faster way?
  df2 <-  data.frame(key = df1$scientificName, 
                     value = do.call(function(...) paste(..., sep="\t"), df1))
  
  ## Write taxonID key (assumes taxonID is unique)
  db$mput(key = df$taxonID, value = df2$value)
  
  ## Write scientificName key, does not assume unique
  ## collapse groups  with `\n`.  base R, bitches
  tmp <- with(df2, tapply(value, key, paste, collapse="\n"))
  db$mput(key = names(tmp), value = tmp)
  
  ## key on vernacular name?
  
  invisible(db)
}


lmdb_path <- function(provider =  getOption("taxadb_default_provider", "itis"),
                      version = latest_version(),
                      dir = taxalight_dir() ){
  file.path(dir, provider, version)
}

taxalight_dir <- function() {
  user_data_dir("taxalight") 
}

dwc_columns <- function() {
  c("taxonID", "scientificName", "acceptedNameUsageID",
    "taxonomicStatus", "taxonRank", "kingdom", "phylum",
    "class", "order", "family", "genus", "specificEpithet",
    "infraspecificEpithet", "vernacularName")
}
