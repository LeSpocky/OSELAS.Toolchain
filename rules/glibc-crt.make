# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel <r.schwebel@pengutronix.de>
#               2013 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
PACKAGES-$(PTXCONF_GLIBC_CRT) += glibc-crt

#
# Paths and names
#
GLIBC_CRT_VERSION	:= $(call remove_quotes,$(PTXCONF_GLIBC_DL_VERSION))
GLIBC_CRT_MD5		:= $(call remove_quotes,$(PTXCONF_GLIBC_MD5))
GLIBC_CRT		:= glibc-$(GLIBC_CRT_VERSION)
GLIBC_CRT_SUFFIX	:= tar.gz
GLIBC_CRT_SOURCE	:= $(SRCDIR)/$(GLIBC_CRT).$(GLIBC_CRT_SUFFIX)
GLIBC_CRT_DIR		:= $(BUILDDIR)/glibc-crt-$(GLIBC_CRT_VERSION)
GLIBC_CRT_BUILDDIR	:= $(GLIBC_CRT_DIR)-build
GLIBC_CRT_URL		 = $(GLIBC_URL)
GLIBC_CRT_BUILD_OOT	:= YES
GLIBC_CRT_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

GLIBC_CRT_PATH := PATH=$(CROSS_PATH)
GLIBC_CRT_ENV := \
	CC="$(CROSS_CC) -fuse-ld=bfd" \
	BUILD_CC=$(HOSTCC) \
	\
	ac_cv_path_GREP=grep \
	ac_cv_sizeof_long_double=$(PTXCONF_SIZEOF_LONG_DOUBLE) \
	libc_cv_c_cleanup=yes \
	libc_cv_forced_unwind=yes

#
# autoconf
#
GLIBC_CRT_CONF_TOOL	:= autoconf
GLIBC_CRT_CONF_OPT	= $(GLIBC_CONF_OPT)
GLIBC_CRT_MAKE_OPT	:= csu/subdir_lib

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

GLIBC_CRT_LIBDIR := lib
ifdef PTXCONF_ARCH_RISCV64
GLIBC_CRT_LIBDIR := lib64/lp64d
endif
ifneq ($(PTXCONF_ARCH_ARM64)$(PTXCONF_ARCH_X86_64)$(PTXCONF_ARCH_MIPS64),)
GLIBC_CRT_LIBDIR := lib64
endif

$(STATEDIR)/glibc-crt.install:
	@$(call targetinfo)
	@mkdir -vp $(SYSROOT)/usr/$(GLIBC_CRT_LIBDIR)
	@for file in {S,}crt1.o crt{i,n}.o; do \
		$(INSTALL) -v -m 644 $(GLIBC_CRT_BUILDDIR)/csu/$$file \
			$(SYSROOT)/usr/$(GLIBC_CRT_LIBDIR)/$$file || exit 1; \
	done
	@$(call touch)

# vim: syntax=make
