# i-d-template assumes the remote is called "origin".  That is true in CI, but
# need not be in anybody's own clone, so use whichever remote this clone has.
GIT_REMOTE ?= $(firstword $(shell git remote))
export GIT_REMOTE

# Without this, i-d-template works out the default branch by looking at
# origin/HEAD, and asks the GitHub API when that does not exist.
DEFAULT_BRANCH := main

LIBDIR := lib
-include $(LIBDIR)/main.mk

$(LIBDIR)/main.mk:
ifneq (,$(shell grep "path *= *$(LIBDIR)" .gitmodules 2>/dev/null))
	git submodule sync
	git submodule update --init
else
ifneq (,$(wildcard $(ID_TEMPLATE_HOME)))
	ln -s "$(ID_TEMPLATE_HOME)" $(LIBDIR)
else
	git clone -q --depth 10 -b main \
	    https://github.com/martinthomson/i-d-template $(LIBDIR)
endif
endif
