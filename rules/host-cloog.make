# -*-makefile-*-
#
# Copyright (C) 2013 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_CLOOG) += host-cloog

#
# Paths and names
#
HOST_CLOOG_VERSION	:= 0.18.4
HOST_CLOOG_MD5		:= e531f725244856c92c9bba009ff44faf
HOST_CLOOG		:= cloog-$(HOST_CLOOG_VERSION)
HOST_CLOOG_SUFFIX	:= tar.gz
HOST_CLOOG_URL		:= http://www.bastoul.net/cloog/pages/download/$(HOST_CLOOG).$(HOST_CLOOG_SUFFIX)
HOST_CLOOG_SOURCE	:= $(SRCDIR)/$(HOST_CLOOG).$(HOST_CLOOG_SUFFIX)
HOST_CLOOG_DIR		:= $(HOST_BUILDDIR)/$(HOST_CLOOG)
HOST_CLOOG_LICENSE	:= LGPL-2.1-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_CLOOG_CONF_TOOL	:= autoconf
HOST_CLOOG_CONF_OPT	:= \
	$(PTX_HOST_AUTOCONF) \
	--disable-shared \
	--enable-static \
	--enable-portable-binary \
	--with-isl=system \
	--with-gmp=system \
	--without-osl

# vim: syntax=make
