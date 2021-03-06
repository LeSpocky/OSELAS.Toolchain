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
HOST_PACKAGES-$(PTXCONF_HOST_XZ) += host-xz

#
# Paths and names
#
HOST_XZ_VERSION	:= 5.2.5
HOST_XZ_MD5	:= 33ab3ef79aa1146b83b778210e7b0a54
HOST_XZ		:= xz-$(HOST_XZ_VERSION)
HOST_XZ_SUFFIX	:= tar.bz2
HOST_XZ_URL	:= http://tukaani.org/xz/$(HOST_XZ).$(HOST_XZ_SUFFIX)
HOST_XZ_SOURCE	:= $(SRCDIR)/$(HOST_XZ).$(HOST_XZ_SUFFIX)
HOST_XZ_DIR	:= $(HOST_BUILDDIR)/$(HOST_XZ)
HOST_XZ_LICENSE	:= public_domain AND LGPL-2.1-or-later AND GPL-2.0-or-later AND GPL-3.0-or-later
HOST_XZ_LICENSE_FILES := \
	file://COPYING;md5=97d554a32881fee0aa283d96e47cb24a \
	file://COPYING.GPLv2;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
	file://COPYING.GPLv3;md5=d32239bcb673463ab874e80d47fae504 \
	file://COPYING.LGPLv2.1;md5=4fbd65380cdd255951079008b364516c

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_XZ_CONF_TOOL	:= autoconf
HOST_XZ_CONF_OPT	:= \
	$(PTX_HOST_AUTOCONF) \
	--disable-debug \
	--disable-external-sha256 \
	--enable-assembler \
	--disable-small \
	--enable-threads \
	--disable-xz \
	--disable-xzdec \
	--disable-lzmadec \
	--disable-lzmainfo \
	--disable-lzma-links \
	--disable-scripts \
	--disable-doc \
	--enable-symbol-versions \
	--disable-sandbox \
	--disable-shared \
	--enable-static \
	--disable-nls \
	--disable-rpath \
	--enable-unaligned-access=auto \
	--disable-werror

# vim: syntax=make
