

## Adapted from `rappdirs`, MIT license (c) Hadley Wickham, RStudio
user_data_dir <- function (appname = NULL, appauthor = appname, version = NULL, 
          roaming = FALSE, expand = TRUE, os = get_os()) 
{
  if (expand) 
    version <- expand_r_libs_specifiers(version)
  if (is.null(appname) && !is.null(version)) {
    version <- NULL
    warning("version is ignored when appname is null")
  }
  switch(os, win = file_path(win_path(ifelse(roaming, "roaming", 
                                             "local")), appauthor, appname, version), 
         mac = file_path("~/Library/Application Support", 
                         appname, version), 
         unix = file_path(Sys.getenv("XDG_DATA_HOME", 
                                                                                                                                                     "~/.local/share"), appname, version))
}

expand_r_libs_specifiers <- function (version_path){
  if (is.null(version_path)) 
    return(NULL)
  rversion <- getRversion()
  version_path <- gsub_special("%V", rversion, version_path)
  version_path <- gsub_special("%v", paste(rversion$major, 
                                           rversion$minor, sep = "."), version_path)
  version_path <- gsub_special("%p", R.version$platform, version_path)
  version_path <- gsub_special("%o", R.version$os, version_path)
  version_path <- gsub_special("%a", R.version$arch, version_path)
  version_path <- gsub("%%", "%", version_path)
  version_path
}

get_os <- function () {
  if (.Platform$OS.type == "windows") {
    "win"
  }
  else if (Sys.info()["sysname"] == "Darwin") {
    "mac"
  }
  else if (.Platform$OS.type == "unix") {
    "unix"
  }
  else {
    stop("Unknown OS")
  }
}

file_path <- function (...) 
{
  normalizePath(do.call("file.path", as.list(c(...))), mustWork = FALSE)
}
