# -*-makefile-*-
#
# Copyright (C) 2011 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_LIBELF) += host-libelf

#
# Paths and names
#
HOST_LIBELF_VERSION	:= 0.179
HOST_LIBELF_MD5		:= 8ee56b371b5a7ea081284c44e5164600
HOST_LIBELF		:= elfutils-$(HOST_LIBELF_VERSION)
HOST_LIBELF_SUFFIX	:= tar.bz2
HOST_LIBELF_URL		:= https://sourceware.org/elfutils/ftp/$(HOST_LIBELF_VERSION)/$(HOST_LIBELF).$(HOST_LIBELF_SUFFIX)
HOST_LIBELF_SOURCE	:= $(SRCDIR)/$(HOST_LIBELF).$(HOST_LIBELF_SUFFIX)
HOST_LIBELF_DIR		:= $(HOST_BUILDDIR)/$(HOST_LIBELF)
HOST_LIBELF_LICENSE	:= (LGPL-3.0-or-later OR GPL-2.0-or-later) AND GPL-3.0-or-later

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
HOST_LIBELF_AUTOCONF := \
	$(PTX_HOST_AUTOCONF) \
	--enable-deterministic-archives \
	--disable-thread-safety \
	--disable-debugpred \
	--disable-gprof \
	--disable-gcov \
	--disable-sanitize-undefined \
	--disable-valgrind \
	--disable-valgrind-annotations \
	--disable-install-elfh \
	--disable-tests-rpath \
	--enable-textrelcheck \
	--enable-symbol-versioning \
	--disable-nls \
	--disable-debuginfod \
	--with-zlib \
	--without-bzlib \
	--with-lzma \
	--without-biarch

ifdef PTXDIST_ICECC
LIBELF_CFLAGS := -C
endif

HOST_LIBELF_MAKE_OPT	:= -C libelf libelf.a
HOST_LIBELF_INSTALL_OPT	:= -C libelf install-data-am install-exec-am

# vim: syntax=make
