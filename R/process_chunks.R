
## Adapted from arkdb

process_chunks <- function(file, 
                           process_fn,
                           lines = 1e5L, 
                           encoding = "UTF-8",
                           ...){
  
  con <- generic_connection(file, "rb", encoding = encoding)
  on.exit(close(con))
  
  header <- readLines(con, n = 1L, encoding = encoding, warn = FALSE)
  if(length(header) == 0){ # empty file, would throw error
    return(NULL)
  }
  reader <- read_chunked(con, lines, encoding)
  
  #p <- progress("Importing to LMDB [:bar] elapsed: :elapsed, eta: :eta", total = total)
  p <- progress("(:spin) Importing chunk :current to LMDB... elapsed: :elapsed", total = NA)
  
  repeat {
    d <- reader()
    body <- paste0(c(header, d$data), "\n", collapse = "")
    p$tick()
    chunk <- stream_table(body, ...)
    process_fn(chunk)
    if (d$complete) {
      break
    }
  }
  message("\n")
}


# Adapted from @richfitz, MIT licensed
read_chunked <- function(con, n, encoding) {
  next_chunk <- readLines(con, n, encoding = encoding, warn = FALSE)
  if (length(next_chunk) == 0L) {
    warning("connection has already been completely read")
    return(function() list(data = character(0), complete = TRUE))
  }
  function() {
    data <- next_chunk
    next_chunk <<- readLines(con, n, encoding = encoding, warn = FALSE)
    complete <- length(next_chunk) == 0L
    list(data = data, complete = complete)
  }
}


#' @importFrom utils read.table
stream_table <- function(file, 
                         sep = "\t", 
                         quote = "", 
                         comment.char = "", 
                         colClasses = "character", ...) {
  utils::read.table(textConnection(file), 
                    header = TRUE, 
                    sep = sep, 
                    quote = quote,
                    comment.char = comment.char,
                    stringsAsFactors = FALSE,
                    colClasses = colClasses,
                    ...)
}


## This is ~~rather desperate~~ terribly innacurate
estimate_chunks <- function(file, lines, encoding="UTF-8"){
  total <- file.size(file)
  x <- readLines(
    file, lines, encoding = encoding, warn = FALSE)
  tmp <- tempfile()
  writeLines(x, gzfile(tmp))
  ceiling(total / file.size(tmp))
}

## We can compute the file-size but not the chunk size.
## So we don't know how many chunks we will need.
progress <- function(txt, clear = FALSE, width = 80, total=NA){
  
  if (requireNamespace("progress", quietly = TRUE)){
    progress_bar <- getExportedValue("progress", "progress_bar")
    p <- progress_bar$new(txt, clear = clear, width = width, total = total)
  } else {
    ## dummy progress bar if we don't have progress installed
    p <- function(){ list(tick = function()  invisible(NULL)) }
  }
  
  p
}
