# -*-makefile-*-
#
# Copyright (C) 2019 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_CLANG) += cross-clang

#
# Paths and names
#
CROSS_CLANG_VERSION		:= $(call remove_quotes,$(PTXCONF_CROSS_CLANG_VERSION))
CROSS_CLANG_MD5			:= $(call remove_quotes,$(PTXCONF_CROSS_CLANG_MD5))
CROSS_CLANG			:= clang-$(CROSS_CLANG_VERSION)
CROSS_CLANG_SUFFIX		:= src.tar.xz
CROSS_CLANG_URL			:= \
	https://releases.llvm.org/$(CROSS_CLANG_VERSION)/$(CROSS_CLANG).$(CROSS_CLANG_SUFFIX) \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(CROSS_CLANG_VERSION)/$(CROSS_CLANG).$(CROSS_CLANG_SUFFIX)
CROSS_CLANG_SOURCE		:= $(SRCDIR)/$(CROSS_CLANG).$(CROSS_CLANG_SUFFIX)
CROSS_CLANG_DIR			:= $(CROSS_BUILDDIR)/$(CROSS_CLANG)
CROSS_CLANG_LICENSE		:= $(call remove_quotes,$(PTXCONF_CROSS_CLANG_LICENSE))
CROSS_CLANG_LICENSE_FILES	:= $(call remove_quotes,$(PTXCONF_CROSS_CLANG_LICENSE_FILES))

ifndef PTXCONF_ARCH_X86_64
CROSS_CLANG_PATCHES		:= none
endif

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

#
# autoconf
#
CROSS_CLANG_CONF_TOOL	:= cmake
CROSS_CLANG_CONF_OPT	 = \
	$(HOST_CMAKE_OPT) \
	-G Ninja \
	-DCMAKE_INSTALL_PREFIX=$(PTXCONF_PREFIX_CROSS) \
	-DCMAKE_SKIP_INSTALL_RPATH=ON \
	-DCMAKE_SKIP_RPATH=ON \
	-DENABLE_LINKER_BUILD_ID=ON \
	-DLLVM_ENABLE_LIBXML2=OFF \
	-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
	-DLLVM_CMAKE_DIR=$(CROSS_LLVM_DIR)-build \
	-DCMAKE_MODULE_PATH=$(CROSS_LLVM_DIR)/cmake/modules \
	-DLLVM_MAIN_INCLUDE_DIR=$(CROSS_LLVM_DIR)/include \
	-DLLVM_BINARY_DIR=$(CROSS_LLVM_DIR)-build

CROSS_CLANG_LDFLAGS	:= \
	-Wl,-rpath,$$ORIGIN/../lib

# Some tools that use libLLVM-*.so are executed at runtime in the build
# directory. So the rpath specified above does not work
CROSS_CLANG_MAKE_ENV	:= \
	LD_LIBRARY_PATH=$(PTXDIST_SYSROOT_CROSS)$(PTXCONF_PREFIX_CROSS)/lib

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

CROSS_CLANG_CROSS_TOOLS := \
	clang \
	clang++ \
	clang-cpp

CROSS_CLANG_TARGET_EXTRA := \
	--target=$(PTXCONF_GNU_TARGET) \
	$(filter-out --%, \
	$(subst --with-arch,-march, \
	$(subst --with-cpu,-mcpu, \
	$(subst --with-float,-mfloat-abi, \
	$(subst --with-fpu,-mfpu, \
	$(subst --with-fpmath,-mfpmath, \
	$(subst --with-mode=,-m, \
	$(subst --with-tune,-mtune, \
	$(PTXCONF_CROSS_GCC_CONFIG_EXTRA)))))))))

define ptx/cross-clang-wrapper-impl
rm -f '$(2)'
echo '#!/bin/sh' > '$(2)'
echo 'd="$$(dirname $$(readlink -f "$${0}"))"' >> '$(2)'
echo '. "$$d/.$(PTXCONF_GNU_TARGET).flags"' >> '$(2)'
echo 'exec "$$d/$(1)" $${flags} \
	--sysroot="$$(dirname "$$d")/sysroot-$(PTXCONF_GNU_TARGET)" "$$@"' \
		>> '$(2)'
chmod +x '$(2)'

endef
define ptx/cross-clang-wrapper
$(call ptx/cross-clang-wrapper-impl,$(strip $(1)),$(strip \
	$(CROSS_CLANG_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(PTXCONF_GNU_TARGET)-$(tool)))
endef

$(STATEDIR)/cross-clang.install:
	@$(call targetinfo)
	@$(call world/install, CROSS_CLANG)
	@echo "flags='$(CROSS_CLANG_TARGET_EXTRA)'" > $(CROSS_CLANG_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/.$(PTXCONF_GNU_TARGET).flags
	@$(foreach tool,$(CROSS_CLANG_CROSS_TOOLS), \
		$(call ptx/cross-clang-wrapper,$(tool)))
	@$(call touch)

# vim: syntax=make
