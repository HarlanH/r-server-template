# Makefile for testapp.R

all : test 
.PHONY : all

test :
	cd scripts && ./runtests.R --quitonerror

OBJS	= scripts/*R 

# work around doubled files when zipping on Mac OS X
export COPYFILE_DISABLE	=	true 

SNAPSHOT_VERSION	:= $(shell git rev-parse --short HEAD)
TAG_VERSION		:= $(shell git describe --tags)

reversion:
	perl -pi -e "s/app\.version <- '.*'/app\.version <- '$(TAG_VERSION)'/" scripts/testapp-config.R

snapshot: $(OBJS) reversion
	tar cvfz testapp-$(SNAPSHOT_VERSION).tgz $(OBJS)

# release does the following
#  confirms we're on the master branch
#  confirms we're up to date 
#  builds a tgz file of stuff to be deployed
release : $(OBJS) test reversion
	- git branch | grep -q "* master" ; 
	- git status | grep -qi "nothing to commit"
	tar cvfz testapp-$(TAG_VERSION).tgz $(OBJS)


