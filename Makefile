###############################################################################
#
# File: Makefile
#
# Copyright 2015 TiVo Inc. All Rights Reserved.
#
###############################################################################

ISM_DEPTH := ..
include $(ISM_DEPTH)/ismdefs

HAXELIB_NAME := lime

# This is defined because this haxelib already has a haxelib.json file and
# doesn't need one to be generated
SUPPRESS_HAXELIB_JSON := 1

PRE_BOM_TARGETS += BuildRunScript

ifeq (android, $(findstring android, $(HAXE_BUILD_TARGET)))
PRE_BOM_TARGETS += BuildLibs BuildNative
endif

ifeq ($(HAXE_BUILD_TARGET),ios)
PRE_BOM_TARGETS += BuildLibs BuildNative
endif

ifeq ($(HAXE_BUILD_TARGET),tvos)
PRE_BOM_TARGETS += BuildLibs BuildNative
endif

ifeq ($(HAXE_TARGET_SYSTEM),host)
PRE_BOM_TARGETS += BuildLibs
endif

# We don't use the standard lime flags here because we are trying to
# build lime the standard OSS way for the host OS, not the "TiVo host"
# emulation way.
# The build tool does not set dynamic_link properly on 64 bit targets, it's
# not clear why.  Work around that here by forcing dynamic_link, which is
# definitely needed for the lime.ndll that these build rules create.
ARGS := -$(HAXE_HOST_BITS) -Dtivo -Ddynamic_link
ifeq ($(QUIET),)
ARGS += -verbose
endif

# Because the stock lime .hxml files always write their output .n files into
# the current directory, and because of the way relative paths are used in
# its build scripts, deep staging is required
DEEP_STAGING_REQUIRED = 1

# Ensure that we don't try to build the BuildLibs and BuildNative
# targets simultaneously.
BUILDLIBSTAMP = $(OBJDIR)/.buildlib


include $(ISMRULES)


.PHONY: BuildRunScript
BuildRunScript: $(HAXELIB_STAGED_DIR)/run.n
$(HAXELIB_STAGED_DIR)/run.n: $(STAGE_HAXELIB_TARGET) tools/run.hxml
	@$(ECHO) -n "$(ISMCOLOR)$(ISM_NAME)$(UNCOLOR): "; \
	$(ECHO) "$(COLOR)Rebuilding Lime command for $(HAXE_HOST_SYSTEM)$(UNCOLOR)";
	$(Q) cd $(HAXELIB_STAGED_DIR)/tools; \
	  $(HAXE) run.hxml

.PHONY: BuildLibs
BuildLibs: $(BUILDLIBSTAMP)
$(BUILDLIBSTAMP): $(HAXELIB_STAGED_DIR)/run.n $(HAXELIB_STAGED_DIR)/tools/tools.n
	@$(ECHO) -n "$(ISMCOLOR)$(ISM_NAME)$(UNCOLOR): "; \
	$(ECHO) "$(COLOR)Rebuilding Lime libraries for $(HAXE_HOST_SYSTEM)$(UNCOLOR)";
	$(Q) cd $(HAXELIB_STAGED_DIR); \
	  neko run.n rebuild $(HAXE_HOST_SYSTEM) $(ARGS) && \
	  touch $(BUILDLIBSTAMP)

.PHONY: BuildNative
BuildNative: $(HAXELIB_STAGED_DIR)/run.n $(HAXELIB_STAGED_DIR)/tools/tools.n $(BUILDLIBSTAMP)
	@$(ECHO) -n "$(ISMCOLOR)$(ISM_NAME)$(UNCOLOR): "; \
	$(ECHO) "$(COLOR)Rebuilding Lime libraries for $(HAXE_BUILD_TARGET)$(UNCOLOR)";
	$(Q) cd $(HAXELIB_STAGED_DIR); \
	  neko run.n rebuild $(HAXE_BUILD_TARGET) $(ARGS)
