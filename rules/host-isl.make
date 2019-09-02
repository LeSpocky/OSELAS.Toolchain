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
HOST_PACKAGES-$(PTXCONF_HOST_ISL) += host-isl

#
# Paths and names
#
HOST_ISL_VERSION	:= 0.21
HOST_ISL_MD5		:= e2be862b79d74234e468981bcae2a964
HOST_ISL		:= isl-$(HOST_ISL_VERSION)
HOST_ISL_SUFFIX		:= tar.bz2
HOST_ISL_URL		:= http://isl.gforge.inria.fr/$(HOST_ISL).$(HOST_ISL_SUFFIX)
HOST_ISL_SOURCE		:= $(SRCDIR)/$(HOST_ISL).$(HOST_ISL_SUFFIX)
HOST_ISL_DIR		:= $(HOST_BUILDDIR)/$(HOST_ISL)
HOST_ISL_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_ISL_CONF_TOOL	:= autoconf
HOST_ISL_CONF_OPT	:= \
	$(PTX_HOST_AUTOCONF) \
	--enable-portable-binary \
	--disable-shared \
	--enable-static \
	--with-int=gmp \
	--with-gmp=system \
	--without-clang

# vim: syntax=make
