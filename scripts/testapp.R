#! /usr/bin/env Rscript

# testapp -- a sample R application that incorporates the following basic features:
#  run as a background process until killed
#  configuration files
#  logging
#  testing
#  web service for status reporting

# USAGE: ./testapp.R /path/to/config.R &

# CC0 1.0 Universal license: http://creativecommons.org/publicdomain/zero/1.0/legalcode


##### STARTUP #####

# source various things, load libraries, etc.

source('testapp-fns.R') # better exist, or fail ugly!

LibraryQuiet('log4r') # requires testthat, digest, stringr, mutatr, evaluate
LibraryQuiet('Rook')

# defaults to be overridden by the config file
print.me.periodically <- '!'
logfile.name <- '/tmp/testapp.log'
log.level <- log4r:::WARN # we've already loaded the package, so OK to use this constant

config.filename <- commandArgs(trailingOnly=TRUE)
tryCatch(source(config.filename),
  error=function(e) { cat('error sourcing', config.filename, '\n', as.character(e), '\n'); QuitWithErr() } )

# set up logging
tryCatch(lgr <- create.logger(logfile=logfile.name, level=log.level),
  error=function(e) { cat('error setting up logger to', logfile.name, '\n', as.character(e), '\n'); QuitWithErr() } )


##### START UP #####

info(lgr, paste(app.name, 'starting up!'))
info(lgr, paste('version', app.version))

periodically.count <- 0

# set up the web service
tryCatch( {
    ws <- Rhttpd$new()
    ws$add(RhttpdApp$new(name='TestAppStatus', app=TestAppStatus))
    ws$start(port=app.port, quiet=TRUE)
    info(lgr, paste('web server at:', ws$full_url(1)))
  },
  error=function(e) { error(lgr, paste('web service failed to start:', as.character(e))) }
)

##### MAIN LOOP #####

MainLoop <- function() {
  while(1) {
    Sys.sleep(1)
    
    cat(print.me.periodically, '\n')
    periodically.count <<- periodically.count + 1
    
    debug(lgr, 'loop')
    # debug(lgr, 'loop2') # see piped logfile that filters this out
    
    if (rnorm(1) > 3.5) stop('random is big!')
  }
}

exit.status <- 0

tryCatch(MainLoop(), 
  interrupt=function(e) { warn(lgr, 'caught interrupt') },
  error=function(e) { fatal(lgr, paste('caught fatal error:', as.character(e))); exit.status <- 1 })

##### SHUT DOWN #####

info(lgr, 'testapp shutting down!')

ws$stop()

QuitWithErr(exit.status)


