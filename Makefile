#!/usr/bin/env make
#
# To develop for canax, clone, pull & push all repos within a single
# directory structure, aided by this Makefile.
# One repo to rule them all.
# See organisation on GitHub: https://github.com/canax


# ------------------------------------------------------------------------
#
# General stuff, reusable for all Makefiles.
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
# http://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux/27776822#27776822
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Which makefile am I in?
WHERE-AM-I = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(ECHO) "$(ACTION)--->" `egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"` "$(NO_COLOR)"

# Check version  and path to command and display on one line
CHECK_VERSION = printf "%-15s %-10s %s\n" "`basename $(1)`" "`$(1) --version $(2)`" "`which $(1)`"

# Print out colored action message
ACTION_MESSAGE = $(ECHO) "$(ACTION)---> $(1)$(NO_COLOR)"



# target: help               - Displays help.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@sed '/^$$/q' $(THIS_MAKEFILE) | tail +3 | sed 's/#\s*//g'
	@$(ECHO) "Usage:"
	@$(ECHO) " make [target] ..."
	@$(ECHO) "target:"
	@egrep "^# target:" $(THIS_MAKEFILE) | sed 's/# target: / /g'



# ------------------------------------------------------------------------
#
# Specifics for this project.
#
BIN        := .bin
NODEMODBIN := node_modules/.bin

ORG := git@github.com:canax

REPOS := \
	anax	 			\
	anax.wiki			\
	anax-design-me		\
	anax-cli 			\
	anax-doc 			\
	anax-flat  			\
	anax-flat2 			\
	anax-flat-theme		\
	anax-flat-website 	\
	anax-lite  			\
	anax-oophp-me		\
	anax-ramverk1-me	\
	anax-website		\
	cache 				\
	common 				\
	commons				\
	content				\
	content-md			\
	controller			\
	configure 			\
	database 			\
	database-query-builder \
	database-active-record \
    devtools			\
    di 					\
	docker  			\
	htmlform 			\
	log 				\
	middleware 			\
	navigation 			\
	page 				\
    panax 				\
    panax.wiki 			\
	proxy 				\
	remserver 			\
	remserver-website	\
	response 			\
	request 			\
	router 				\
	scaffold 			\
	session 			\
	stylechooser		\
	textfilter 			\
	uri 				\
	url  				\
	view 				\

# anax-flat  			\ # move to own anax-flat organisation
# anax-flat-theme		\ # move to desinax or maybe anax-flat organisation
# anax-flat-website 	\ # move to own anax-flat organisation
# anax-lite 			\ # move to own organisation?



# # target: prepare            - Prepare for tests and build
# .PHONY:  prepare
# prepare:
# 	@$(call HELPTEXT,$@)
# 	[ -d .bin ] || mkdir .bin
# 	[ -d build ] || mkdir build
# 	rm -rf build/*
#
#
#
# target: clone              - Clone all repos
.PHONY:  clone
clone: clone-repos
	@$(call HELPTEXT,$@)



# target: pull               - Pull latest from all repos
.PHONY:  pull
pull: pull-repos
	@$(call HELPTEXT,$@)
	git pull



# target: status             - Check status on all repos
.PHONY:  status
status: status-repos
	@$(call HELPTEXT,$@)
	git status



# # target: install            - Install all repos
# .PHONY:  install
# install:
# 	@$(call HELPTEXT,$@)
#
#
#
# # target: update             - Update this dev-repo and all other repos.
# .PHONY:  update
# update:
# 	@$(call HELPTEXT,$@)
# 	git pull
# 	$(MAKE) pull
# 	# [ ! -f composer.json ] || composer update
# 	# [ ! -f package.json ] || npm update



# target: clean              - Removes generated files and directories.
.PHONY: clean
clean:
	@$(call HELPTEXT,$@)



# # target: clean-cache        - Clean the cache.
# .PHONY:  clean-cache
# clean-cache:
# 	@$(call HELPTEXT,$@)
# 	#rm -rf cache/*/*



# target: clean-all          - Removes all generated files and repost.
.PHONY:  clean-all
clean-all: clean clean-cache clean-repos
	@$(call HELPTEXT,$@)
	#rm -rf .bin vendor node_modules



# # target: check              - Check version of installed tools.
# .PHONY:  check
# check: check-tools-js #check-tools-bash check-tools-php
# 	@$(call HELPTEXT,$@)
#
#
#
# # target: test               - Run all tests.
# .PHONY: test
# test: htmlhint stylelint eslint jsunittest
# 	@$(call HELPTEXT,$@)
# 	[ ! -f composer.json ] || composer validate
#
#
#
# # target: doc                - Generate documentation.
# .PHONY: doc
# doc:
# 	@$(call HELPTEXT,$@)
#
#
#
# # target: build              - Do all build
# .PHONY: build
# build: test doc #theme less-compile less-minify js-minify
# 	@$(call HELPTEXT,$@)
#
#
#
# # target: tag-prepare        - Prepare to tag new version.
# .PHONY: tag-prepare
# tag-prepare:
# 	@$(call HELPTEXT,$@)
# 	@grep '^v[0-9]\.' REVISION.md | head -1
# 	@grep version package.json
# 	@git describe --abbrev=0
# 	@git status



# ------------------------------------------------------------------------
#
# Top level repos
#

# target: clone-repos        - Clone all general repos.
.PHONY: clone-repos
clone-repos:
	@$(call HELPTEXT,$@)
	for repo in $(REPOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		[ -d $$repo ]                       \
			&& $(ECHO) "Repo already there, skipping cloning it." \
			&& continue;                    \
		git clone $(ORG)/$$repo.git;        \
	done



# target: pull-repos         - Pull latest for all general repos.
.PHONY: pull-repos
pull-repos:
	@$(call HELPTEXT,$@)
	for repo in $(REPOS) ; do               \
		$(call ACTION_MESSAGE,$$repo);      \
		(cd $$repo && git pull);            \
	done



# target: clean-repos        - Remove all top general repos.
.PHONY: clean-repos
clean-repos:
	@$(call HELPTEXT,$@)
	rm -rf $(REPOS)



# target: status-repos       - Check status of each general repo.
.PHONY: status-repos
status-repos:
	@$(call HELPTEXT,$@)
	for repo in $(REPOS) ; do                    \
		$(call ACTION_MESSAGE,$$repo);           \
		(cd $$repo && git status);               \
	done



# target: check-repos        - Check details of each general repo.
.PHONY: check-repos
check-repos:
	@$(call HELPTEXT,$@)
	for repo in $(REPOS) ; do                       \
		$(call ACTION_MESSAGE,$$repo);              \
		du -sk $$repo/.git;                         \
	done
