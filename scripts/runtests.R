#! /usr/bin/env Rscript

# ./runtests.R ( --quitonerror )

library(testthat)

source("testapp-fns.R")

args <- commandArgs(trailingOnly=TRUE)

test_dir('tests/')

if (length(args) > 0 && '--quitonerror' %in% args[[1]]) {
  tryCatch(test_dir('tests/', reporter='stop'), 
    error=function(e) { quit(save='no', status=1) } )
}
