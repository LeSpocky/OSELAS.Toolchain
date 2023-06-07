# -*-makefile-*-
#
# Copyright (C) 2020 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_LLD) += cross-lld

#
# Paths and names
#
CROSS_LLD_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_LLD_VERSION))
CROSS_LLD_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_LLD_MD5))
CROSS_LLD		:= lld-$(CROSS_LLD_VERSION)
CROSS_LLD_SUFFIX	:= src.tar.xz
CROSS_LLD_URL		:= \
	https://releases.llvm.org/$(CROSS_LLD).$(CROSS_LLD_SUFFIX) \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(CROSS_LLD_VERSION)/$(CROSS_LLD).$(CROSS_LLD_SUFFIX)
CROSS_LLD_SOURCE	:= $(SRCDIR)/$(CROSS_LLD).$(CROSS_LLD_SUFFIX)
CROSS_LLD_DIR		:= $(CROSS_BUILDDIR)/$(CROSS_LLD)
CROSS_LLD_LICENSE	:= $(call remove_quotes,$(PTXCONF_CROSS_LLD_LICENSE))
CROSS_LLD_LICENSE_FILES	:= $(call remove_quotes,$(PTXCONF_CROSS_LLD_LICENSE_FILES))

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# cmake
#
CROSS_LLD_CONF_TOOL	:= cmake
CROSS_LLD_CONF_OPT	:=  \
	$(HOST_CROSS_CMAKE_OPT) \
	-G Ninja \
	-DCMAKE_INSTALL_PREFIX=$(PTXCONF_PREFIX_CROSS) \
	-DCMAKE_SKIP_INSTALL_RPATH=ON \
	-DCMAKE_SKIP_RPATH=ON \
	-DLLD_USE_VTUNE=OFF \
	-DLLD_BUILD_TOOLS=ON \
	-DLLVM_CONFIG_PATH=$(CROSS_LLVM_DIR)-build/bin/llvm-config


CROSS_LLD_LDFLAGS	:= \
	-Wl,-rpath,$$ORIGIN/../lib

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

$(STATEDIR)/cross-lld.install:
	@$(call targetinfo)
	@$(call world/install, CROSS_LLD)
	@install -vd -m755 \
		$(CROSS_LLD_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin
	@ln -sfv  \
		../../bin/lld \
		$(CROSS_LLD_PKGDIR)$(PTXCONF_PREFIX_CROSS)/$(PTXCONF_GNU_TARGET)/bin/ld.lld
	@$(call touch)

# vim: syntax=make
