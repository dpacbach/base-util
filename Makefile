.DEFAULT_GOAL := all
build-current := .builds/current

-include $(build-current)/env-vars.mk

build-config := $(notdir $(realpath $(build-current)))
ifneq (,$(findstring make,$(build-config)))
    # Here we are invoking $(MAKE) directly instead of using
    # cmake because otherwise there seem to be issues with
    # propagating the jobserver.  For this same reason we
    # also do not just put the whole command into a variable
    # and just define the targets once.
    all clean: $(build-current)
	    @cd $(build-current) && $(MAKE) -s $@
else
    # Use cmake to build here because it is the preferred
    # way to go when it works for us (which it does in this
    # case).
    all clean: $(build-current)
	    @cd $(build-current) && cmake --build . --target $@
endif

run: all
	@$(build-current)/app/main

test: all
	@$(build-current)/test/tests

distclean:
	@rm -rf .builds

$(build-current):
	@cmc

.PHONY: all run clean test distclean
