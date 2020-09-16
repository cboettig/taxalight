

#' @examples
#' ids <- c("COL:35517330", "COL:35517332", "COL:35517329", "COL:35517325")
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")
#' 
#' tl(sp)
#' tl(id, "col")
tl_id <- function(name,
                  provider = getOption("taxadb_default_provider", "itis"),
                  version = latest_version(),
                  dir = taxadb_dir()){
  
  
  db <- lmdb_init(lmdb_path(provider, version, dir))
  
  ## dbs may not all use same columns in same order. enforce!
  col.names <- dwc_columns()
  lmdb_read(db, name, col.names, colClasses = "character")
  
}



