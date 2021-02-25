

first_8_bytes <- function(x) readBin(x, n = 8, what = "raw")

compression_signature <- function(x){
  
  # https://en.wikipedia.org/wiki/List_of_file_signatures
  gz_sig <- as.raw(c("0x1F", "0x8B"))
  bz2_sig <- as.raw(paste0("0x", c("42", "5A", "68")))
  xz_sig <- as.raw(paste0("0x", c("FD", "37", "7A", "58", "5A", "00")))
  
  sig <- first_8_bytes(x)  
  
  if(identical(gz_sig, sig[1:2]))
    return("gzip")
  if(identical(bz2_sig, sig[1:3]))
    return("bz2")
  if(identical(xz_sig, sig[1:6]))
    return("xz")
  ""
  
}


generic_connection <- function(path, ...) {
  
    con <- switch(compression_signature(path),
                  gzip = gzfile(path, ...),
                  bz2 = bzfile(path, ...),
                  xz = xzfile(path, ...),
                  zip = unz(path, ...),
                  file(path, ...))
    
}


na_omit <- function(x) x[!is.na(x)]
null_to_empty <- function(x) {
  x[vapply(x, is.null, logical(1))] <- ""
  x
}


