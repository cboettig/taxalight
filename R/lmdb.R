
#' @importFrom thor mdb_env
lmdb_init <- function(path) {
  thor::mdb_env(path, mapsize = mapsize()) ## ~1 TB
}


lmdb_read <- function(db, id, ...) {
  out <- db$mget(id, FALSE)
  lmdb_parse(out, ...)
}



## parse text string back into a data.frame
lmdb_parse <- function(x, col.names, colClasses = NA){
  if(all(x %in% "")) return(data.frame())
  text <- paste0(x, collapse="\n")
  tmp <- read.table(text = text, 
                    header = FALSE, 
                    sep = "\t", 
                    quote = "", 
                    nrows = 1)
  n <- length(tmp)
  ## consider a faster parser than read.table!
  df <- read.table(text = text,
                   header = FALSE, 
                   sep = "\t",
                   quote = "",  
                   colClasses = colClasses[1:n],
                   col.names = col.names[1:n])
  ## collapse any duplicates:
  unique(df)
}

## Txt is tab-collapsed table,   
## `txt = do.call(function(...) paste(..., sep="\t"), df1)`
lmdb_serialize <- function(db, txt, group_id){
  
  valid <- !is.na(group_id)
  if(!any(valid)) return(NULL)
  ## Combine any rows sharing a match group_id to a "\n"-sep string
  value <- tapply(txt[valid], group_id[valid], paste, collapse="\n")
  key <- names(value)
  ## since we stream in chunks, some matches may be in db already
  ## we append these with \n as well.  
  existing <- null_to_empty(db$mget(key))
  duplicates <- which(existing == value)
  existing[duplicates] <- ""
  value <- paste(existing, value, sep="\n")
  ## and write to database
  db$mput(key = key, value = value)
} 

lmdb_path <- function(provider =  getOption("tl_default_provider", "itis"),
                      version = tl_latest_version(),
                      dir = tl_dir() ){
  file.path(dir, provider, version)
}

## Windows throws errors on larger maps?
mapsize <- function(){
  if (.Platform$OS.type == "windows") {
    return(9e9)
  } else if (grepl("SunOS", Sys.info()["sysname"])){
    return(NULL)
  }
  1e12
}
