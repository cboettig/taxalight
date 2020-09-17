
#' @importFrom thor mdb_env
lmdb_init <- function(path) {
  #if (!requireNamespace("thor", quietly = TRUE)){
  #  stop("Please install package `thor` to use LMDB backend")
  #}
  #mdb_env <- getExportedValue("thor", "mdb_env")
  thor::mdb_env(path, mapsize = mapsize()) ## ~1 TB
}


lmdb_read <- function(db, id, ...) {
  out <- db$mget(id, FALSE)
  lmdb_parse(out, ...)
}

## parse text string back into a data.frame
lmdb_parse <- function(x, col.names, colClasses = NA){
  ## consider a faster parser than read.table!
  read.table(text = paste0(x, collapse="\n"),
             header = FALSE, sep = "\t",
             quote = "",  colClasses = colClasses,
             col.names = col.names)
}

## Windows throws errors on larger maps?
mapsize <- function(){
  if (.Platform$OS.type == "windows") {
    return(1e9)
  }
  1e12
}
