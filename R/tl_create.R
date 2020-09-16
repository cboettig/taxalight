



lmdb_create <- function(provider = getOption("taxadb_default_provider", "itis"),
                        version = latest_version(),
                        dir =  taxalight_dir(),
                        ...){
  
  db <- lmdb_init(lmdb_path(provider, version, dir))
  lambda <- function(chunk) lmdb_importer(chunk, db)
  
  paths <- tl_import(provider, schema, version)
  
  lapply(paths,
         process_chunks,
         lambda)
  
}


lmdb_importer <- function(df, db){
  
  ## collapse columns with `\t`
  df2 <-  data.frame(key = df$scientificName, 
                     value = do.call(function(...) paste(..., sep="\t"), df))
  
  ## Write taxonID key (assumes taxonID is unique)
  db$mput(key = df$taxonID, value = df2$value)
  
  ## Write scientificName key, does not assume unique
  ## collapse groups  with `\n`.  base R, bitches
  tmp <- with(df2, tapply(value, key, paste, collapse="\n"))
  db$mput(key = names(tmp), value = tmp)
  
  invisible(db)
}


lmdb_path <- function(provider =  getOption("taxadb_default_provider", "itis"),
                      version = latest_version(),
                      dir = taxalight_dir() ){
  file.path(dir, provider, version)
}

taxalight_dir <- function() user_data_dir("taxalight")
