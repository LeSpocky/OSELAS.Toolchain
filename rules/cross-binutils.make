# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_BINUTILS) += cross-binutils

#
# Paths and names
#
CROSS_BINUTILS_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_BINUTILS_VERSION))
CROSS_BINUTILS_MD5	:= $(call remove_quotes,$(PTXCONF_CROSS_BINUTILS_MD5))
CROSS_BINUTILS		:= binutils-$(CROSS_BINUTILS_VERSION)
CROSS_BINUTILS_SUFFIX	:= tar.bz2
CROSS_BINUTILS_SOURCE	:= $(SRCDIR)/$(CROSS_BINUTILS).$(CROSS_BINUTILS_SUFFIX)
CROSS_BINUTILS_DIR	:= $(CROSS_BUILDDIR)/$(CROSS_BINUTILS)
CROSS_BINUTILS_BUILDDIR	:= $(CROSS_BUILDDIR)/$(CROSS_BINUTILS)-build
CROSS_BINUTILS_LICENSE	:= $(call remove_quotes,$(PTXCONF_CROSS_BINUTILS_LICENSE))
CROSS_BINUTILS_LICENSE_FILES := $(call remove_quotes,$(PTXCONF_CROSS_BINUTILS_LICENSE_FILES))

CROSS_BINUTILS_URL	:= \
	$(call ptx/mirror, GNU, binutils/$(CROSS_BINUTILS).$(CROSS_BINUTILS_SUFFIX)) \
	https://www.sourceware.org/pub/binutils/snapshots/$(CROSS_BINUTILS).$(CROSS_BINUTILS_SUFFIX) \
	http://www.kernel.org/pub/linux/devel/binutils/$(CROSS_BINUTILS).$(CROSS_BINUTILS_SUFFIX)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CROSS_BINUTILS_CONF_ENV	:= \
	$(HOST_CROSS_ENV) \
	CFLAGS="-ggdb3 -O2" \
	CXXFLAGS="-ggdb3 -O2"

ifneq ($(PTXCONF_ARCH_ARM64)$(PTXCONF_ARCH_X86_64)$(PTXCONF_ARCH_MIPS64),)
CROSS_BINUTILS_LIBDIR := lib64
else
CROSS_BINUTILS_LIBDIR := lib
endif

#
# autoconf
#
CROSS_BINUTILS_CONF_TOOL	:= autoconf
CROSS_BINUTILS_CONF_OPT		:= \
	$(PTX_HOST_CROSS_AUTOCONF) \
	$(PTXCONF_TOOLCHAIN_CONFIG_SYSROOT) \
	--with-lib-path="=/../$(PTX_TOUPLE_TARGET)/$(CROSS_BINUTILS_LIBDIR):=/$(CROSS_BINUTILS_LIBDIR):=/usr/$(CROSS_BINUTILS_LIBDIR)" \
	\
	--$(call ptx/endis,PTXCONF_CROSS_BINUTILS_GOLD)-gold \
	--enable-ld=default \
	--disable-gprofng \
	--enable-default-compressed-debug-sections-algorithm=zstd \
	--disable-werror \
	--with-system-zlib \
	--with-zstd \
	\
	--enable-threads \
	--enable-plugins

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cross-binutils.install: $(STATEDIR)/cross-binutils.report
	@$(call targetinfo)
	@$(call world/install, CROSS_BINUTILS)
#	# this link first in case it is moved to $(COMPILER_PREFIX)ld.real
	@ln -vsf $(COMPILER_PREFIX)ld.bfd \
		$(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)ld
ifdef PTXCONF_CROSS_BINUTILS_LD_REAL
	mv -v $(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)ld \
		$(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)ld.real
	mv -v $(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/ld \
		$(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/ld.real
endif
#	# these links last to ensure that ld.real points to $(COMPILER_PREFIX)ld.real
	@for bin in $(CROSS_BINUTILS_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/*; do \
		ln -vsf ../../bin/$(COMPILER_PREFIX)$$(basename $${bin}) $${bin} || break; \
	done

	@$(call world/env, CROSS_BINUTILS) \
		pkg_license_target=binutils \
		pkg_license_target_license=$(PTXCONF_CROSS_BINUTILS_LICENSE) \
		pkg_license_target_pattern=$(PTXCONF_CROSS_BINUTILS_LICENSES) \
		ptxd_make_world_copy_license

	@$(call touch)

$(STATEDIR)/cross-binutils.install.post:
	@$(call targetinfo)
	@$(call world/install.post, CROSS_BINUTILS)
	mkdir -p "$(CROSS_GCC_FIRST_PREFIX)/$(PTXCONF_GNU_TARGET)/bin"
	for file in \
		ar \
		as \
		ld \
		nm \
		objcopy \
		objdump \
		ranlib \
		strip \
		; do \
		ln -sf "$(PTXDIST_SYSROOT_CROSS)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/$$file" \
			"$(CROSS_GCC_FIRST_PREFIX)/$(PTXCONF_GNU_TARGET)/bin/$$file"; \
	done

	@$(call touch)

# vim: syntax=make
