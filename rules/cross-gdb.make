# -*-makefile-*-
#
# Copyright (C) 2006, 2007, 2008 by Marc Kleine-Budde <mkl@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_GDB) += cross-gdb

#
# Paths and names
#
CROSS_GDB_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_GDB_VERSION))
CROSS_GDB_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_GDB_MD5))
CROSS_GDB		:= gdb-$(CROSS_GDB_VERSION)
CROSS_GDB_SUFFIX	:= tar.xz
CROSS_GDB_SOURCE	:= $(SRCDIR)/$(CROSS_GDB).$(CROSS_GDB_SUFFIX)
CROSS_GDB_DIR		:= $(CROSS_BUILDDIR)/$(CROSS_GDB)
CROSS_GDB_LICENSE	:= $(call remove_quotes,$(PTXCONF_CROSS_GDB_LICENSE))
CROSS_GDB_LICENSE_FILES	:= $(call remove_quotes,$(PTXCONF_CROSS_GDB_LICENSE_FILES))
CROSS_GDB_BUILD_OOT	:= YES

CROSS_GDB_URL		:= \
	$(call ptx/mirror, GNU, gdb/$(CROSS_GDB).$(CROSS_GDB_SUFFIX)) \
	https://sourceware.org/pub/gdb/snapshots/current/$(CROSS_GDB).$(CROSS_GDB_SUFFIX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CROSS_GDB_CONF_ENV	:= \
	$(HOST_CROSS_ENV) \
	CFLAGS="-ggdb3 -O2" \
	CXXFLAGS="-ggdb3 -O2"

#
# autoconf
#
CROSS_GDB_CONF_TOOL	:= autoconf
CROSS_GDB_CONF_OPT	:= \
	$(PTX_HOST_CROSS_AUTOCONF) \
	$(PTXCONF_TOOLCHAIN_CONFIG_SYSROOT) \
	\
	--disable-werror \
	--enable-tui \
	--with-expat \
	--without-guile \
	--with-python=python3

# vim: syntax=make
