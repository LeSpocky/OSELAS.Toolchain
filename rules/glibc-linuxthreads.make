# -*-makefile-*-
# $Id: template 6001 2006-08-12 10:15:00Z mkl $
#
# Copyright (C) 2006 by Marc Kleine-Budde <mkl@pengutronix.de>
#          
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLIBC_LINUXTHREADS) += glibc-linuxthreads

#
# Paths and names
#
GLIBC_LINUXTHREADS_VERSION	:= $(call remove_quotes,$(PTXCONF_GLIBC_LINUXTHREADS_VERSION))
GLIBC_LINUXTHREADS		:= glibc-linuxthreads-$(GLIBC_LINUXTHREADS_VERSION)
GLIBC_LINUXTHREADS_SUFFIX	:= tar.bz2
GLIBC_LINUXTHREADS_URL		:= $(PTXCONF_SETUP_GNUMIRROR)/glibc/$(GLIBC_LINUXTHREADS).$(GLIBC_LINUXTHREADS_SUFFIX)
GLIBC_LINUXTHREADS_SOURCE	:= $(SRCDIR)/$(GLIBC_LINUXTHREADS).$(GLIBC_LINUXTHREADS_SUFFIX)
GLIBC_LINUXTHREADS_DIR		:= $(BUILDDIR)/$(GLIBC_LINUXTHREADS)

# ----------------------------------------------------------------------------
# Get
# ----------------------------------------------------------------------------

glibc-linuxthreads_get: $(STATEDIR)/glibc-linuxthreads.get

$(STATEDIR)/glibc-linuxthreads.get: $(glibc-linuxthreads_get_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

$(GLIBC_LINUXTHREADS_SOURCE):
	@$(call targetinfo, $@)
	@$(call get, GLIBC_LINUXTHREADS)

# ----------------------------------------------------------------------------
# Extract
# ----------------------------------------------------------------------------

ifdef PTXCONF_GLIBC_LINUXTHREADS
$(STATEDIR)/glibc.extract: $(STATEDIR)/glibc-linuxthreads.extract
endif

glibc-linuxthreads_extract: $(STATEDIR)/glibc-linuxthreads.extract

$(STATEDIR)/glibc-linuxthreads.extract: $(glibc-linuxthreads_extract_deps_default)
	@$(call targetinfo, $@)
	@$(call clean, $(GLIBC_LINUXTHREADS_DIR))
	@$(call extract, GLIBC_LINUXTHREADS, $(GLIBC_LINUXTHREADS_DIR))
	@$(call patchin, GLIBC_LINUXTHREADS, $(GLIBC_LINUXTHREADS_DIR))
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

glibc-linuxthreads_prepare: $(STATEDIR)/glibc-linuxthreads.prepare

$(STATEDIR)/glibc-linuxthreads.prepare: $(glibc-linuxthreads_prepare_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

glibc-linuxthreads_compile: $(STATEDIR)/glibc-linuxthreads.compile

$(STATEDIR)/glibc-linuxthreads.compile: $(glibc-linuxthreads_compile_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

glibc-linuxthreads_install: $(STATEDIR)/glibc-linuxthreads.install

$(STATEDIR)/glibc-linuxthreads.install: $(glibc-linuxthreads_install_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Target-Install
# ----------------------------------------------------------------------------

glibc-linuxthreads_targetinstall: $(STATEDIR)/glibc-linuxthreads.targetinstall

$(STATEDIR)/glibc-linuxthreads.targetinstall: $(glibc-linuxthreads_targetinstall_deps_default)
	@$(call targetinfo, $@)
	@$(call touch, $@)

# ----------------------------------------------------------------------------
# Clean
# ----------------------------------------------------------------------------

glibc-linuxthreads_clean:
	rm -rf $(STATEDIR)/glibc-linuxthreads.*
	rm -rf $(IMAGEDIR)/glibc-linuxthreads_*
	rm -rf $(GLIBC_LINUXTHREADS_DIR)

# vim: syntax=make
