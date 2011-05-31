# helper functions for the test app

QuitWithErr <- function(errnum=10) quit(save='no', status=errnum, runLast=TRUE)
# if .Last() exists, will be run

LibraryQuiet <- function(ll) suppressPackageStartupMessages(library(ll, character.only=TRUE))

NA2z <- function(x, z) {
  # Replaces NAs in vectors and flat lists with whatever z is.
  #
  # Args:
  #   x: a vector or list; can be 0-length
  #   z: a 1-length constant to be used to replace NAs
  #
  # Returns:
  #   a vector or list of the same size as x
  #####
  
  stopifnot(length(z)==1)
  if (length(x) > 0) { 
    ret <- ifelse(is.na(x), z, x)
    if (is.list(x)) as.list(ret) else ret
  } else x
}
NA2F <- function(x) NA2z(x, FALSE)
NA20 <- function(x) NA2z(x, 0) 
NA2Inf <- function(x) NA2z(x, Inf)
NA2mean <- function(x) { stopifnot(is.numeric(x)); NA2z(x, mean(x, na.rm=TRUE)) }

TestAppStatus <- function(req.env) {
  # Rook/Rhttpd hook to display the application status
  #
  # Args:
  #   req.env - an environment with request objects
  #
  # Returns: a response object
  #######
  
  req <- Request$new(req.env)
  res <- Response$new()
  
  res.html.str <- '<HTML><head><title>%s</title></head>
    <body>
    <h1>%s %s</h1>
    <p>Have printed &quot;%s&quot; %d times.<p>
    </body>
    </HTML>
    '
  res$write(sprintf(res.html.str, app.name, app.name, app.version, print.me.periodically, periodically.count))
  res$finish()
}