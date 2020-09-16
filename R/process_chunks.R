
process_chunks <- function(file, 
                           process_fn,
                           lines = 5e4L, 
                           encoding = "UTF-8",
                           ...){
  
  con <- compressed_file(file, "rb", encoding = encoding)
  on.exit(close(con))
  
  header <- readLines(con, n = 1L, encoding = encoding, warn = FALSE)
  if(length(header) == 0){ # empty file, would throw error
    return(NULL)
  }
  reader <- read_chunked(con, lines, encoding)
  # May throw an error if we need to read more than 'total' chunks?
  p <- progress("Importing [:bar] :percent eta: :eta")
  t0 <- Sys.time()
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
  message(sprintf("\t...Done! (in %s)", format(Sys.time() - t0)))
}


# Adapted from @richfitz, MIT licensed
read_chunked <- function(con, n, encoding) {
  assert_connection(con)
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


file_ext <- function(x) {
  pos <- regexpr("\\.([[:alnum:]]+)$", x)
  ifelse(pos > -1L, substring(x, pos + 1L), "")
}

compressed_file <- function(path, ...){
  con <- switch(file_ext(path),
                gz = gzfile(path, ...),
                bz2 = bzfile(path, ...),
                xz = xzfile(path, ...),
                zip = unz(path, ...),
                file(path, ...))
}


progress <- function(txt, total = 100000){
  
  if (requireNamespace("progress", quietly = TRUE)){
    progress_bar <- getExportedValue("progress", "progress_bar")
    p <- progress_bar$new("[:spin] chunk :current", total = 100000)
  } else {
    ## dummy progress bar if we don't have progress installed
    p <- function(){ list(tick = function()  invisible(NULL)) }
  }
  
  p
}
