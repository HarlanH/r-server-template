R-Server-Template
=================

Harlan D. Harris
harlan@harris.name

This template is [CC0 1.0 Universal](http://creativecommons.org/publicdomain/zero/1.0/legalcode)
licensed, meaning it is released into the public domain.

## Description ##

This application framework demonstrates how you can write an R application that runs 
continuously as a server. For example, you could extend this application to periodically
read data from a file or database, perform some statistical tests or analyses, and 
put the results in another file or database. This framework will work on unix-alike 
(Linux, Mac OS X) machines, but not under Windows.

Features include:

* configuration -- a filename specified on the command line will be sourced, over-riding
default parameters, such as the location of a log file

* logging -- demonstrates John Myles White's handy `log4r` package

* error handling -- captures runtime errors cleanly and logs them

* continuous execution -- loops until dies or shuts down

* clean shutdown -- captures the SIGKILL (^C) signal and performs a clean shutdown, complete
with logging

* packaging -- includes a Makefile that creates a package suitable for installation on a server,
separate from the source tree

* versioning -- uses version and tag information from a github repository to tag the application's 
version number

* testing -- uses Hadley Wickham's `testthat` package to test the NA2x functions

* status via web service -- using R 2.13.0's new web server and Jeffrey Horner's `Rook` package, 
exposes a web page that reports the application

The actual application does nothing useful, outputting a (parameterized) string to stdout every
second, until killed or dies (due to a statistically rare event).

## Running ##

* First, from the main directory, `make test` to see that all tests pass.

* Second, `make snapshot` to build an installation archive. If you'd like, copy that to where
you'd like to run the server and extract it with `tar xvfz testapp-whatever.tgz`.

* Third, set up the `testapp-config.R` file as you prefer.

* Fourth, install the `log4r` and `Rook` R libraries and their dependencies.

* Fifth, run the application: `./testapp.R /path/to/config.R` in a terminal window.

* Sixth, verify that the application is running. Watch the dots appear. Look at the log file.
Hit the web server.

* Seventh, hit ctrl-C to kill the application. Look at the log file again to see the clean shutdown.


## Library Functions ##

The `testapp-fns.R` file includes several useful functions.

`QuitWithErr` exits the application with a specified (default is 10) exit status.

`LibraryQuiet` wraps the `library()` function to suppress startup messages.

`NA2F`, `NA20`, `NA2Inf`, and `NA2mean` implement handy vectorized functions that replace
NAs in a vector (or list) with appropriate replacements. Tested by the `runtests.R` script.
Note that these return reasonably typed results even with 1-length or 0-length inputs, which 
the wrapped `ifelse()` function does not consistently do.

`TestAppStatus` is a Rook applet that provides information about the status of the 
application to an administrator.

## Directories ##

The _scripts_ directory contains the Rscript scripts that make up the application.
The _tests_ subdirectory contains `testthat` scripts.

## Makefile ##

Targets are as follows:

* test -- to run tests. Note that the current version of `testthat` does not support 
simultaneously quitting with an exit status and printing the output. Therefore, the 
`runtests.R` script runs the tests once, outputting to the screen, then if the
`--quitonerr` flag is provided, runs the tests again quietly, quitting if there's a problem. 
As a result, `runtests.R` exits with a non-zero exit status if any tests fail.

* reversion -- to tag the app with a git version tag

* snapshot -- to build a snapshot release, based on the git SHA of the current branch.

* release -- to build a versioned release. Throws warnings if not on an up-to-date master
branch, and tags the application and the archive file based on the most recent tag.



