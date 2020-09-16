

#' @examples
#' ids <- c("COL:35517330", "COL:35517332", "COL:35517329", "COL:35517325")
#' sp <- c("Dendrocygna autumnalis", "Dendrocygna bicolor")

tl_name <- function(name,
                      provider = getOption("taxadb_default_provider", "itis"),
                      version = latest_version(),
                      dir = taxadb_dir()){
  
  
  db <- lmdb_init(lmdb_path(provider, version, dir))
  
  col.names <- c("taxonID", "scientificName", "acceptedNameUsageID",
                 "taxonomicStatus", "taxonRank", "kingdom", "phylum",
                 "class", "order", "family", "genus", "specificEpithet",
                 "infraspecificEpithet", "vernacularName")
  lmdb_read(db, name, col.names, colClasses = "character")
  
}

tl_id <- lmdb_name


latest_version <- function() 2020