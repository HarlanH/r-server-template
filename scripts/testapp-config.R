
print.me.periodically <- '.'

# full or relative filename, or a '|pipe command'
logfile.name <- '/tmp/testapp.log'
#logfile.name <- '|grep -v loop2 >> /tmp/testapp.log'

# one of log4r:::DEBUG, INFO, WARN, ERROR, or FATAL
log.level <- log4r:::DEBUG

# status web service info
app.name <- 'TestApp'
app.version <- 'v0.0.1' # replaced dynamically
app.port <- 9898