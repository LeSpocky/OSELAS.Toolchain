# -*-makefile-*-
#
# Copyright (C) 2012 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_EXPAT) += host-expat

#
# Paths and names
#
HOST_EXPAT_VERSION	:= 2.2.9
HOST_EXPAT_MD5		:= 875a2c2ff3e8eb9e5a5cd62db2033ab5
HOST_EXPAT		:= expat-$(HOST_EXPAT_VERSION)
HOST_EXPAT_SUFFIX	:= tar.bz2
HOST_EXPAT_URL		:= $(call ptx/mirror, SF, expat/$(HOST_EXPAT).$(HOST_EXPAT_SUFFIX))
HOST_EXPAT_SOURCE	:= $(SRCDIR)/$(HOST_EXPAT).$(HOST_EXPAT_SUFFIX)
HOST_EXPAT_DIR		:= $(HOST_BUILDDIR)/$(HOST_EXPAT)
HOST_EXPAT_LICENSE	:= MIT

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_EXPAT_CONF_TOOL	:= autoconf
HOST_EXPAT_CONF_OPT	:= \
	$(PTX_HOST_AUTOCONF) \
	--disable-shared \
	--enable-static \
	--enable-xml-context \
	--without-xmlwf \
	--without-libbsd

# vim: syntax=make
