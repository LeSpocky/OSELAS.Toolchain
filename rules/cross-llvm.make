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
CROSS_PACKAGES-$(PTXCONF_CROSS_LLVM) += cross-llvm

#
# Paths and names
#
CROSS_LLVM_VERSION		:= $(call remove_quotes,$(PTXCONF_CROSS_LLVM_VERSION))
CROSS_LLVM_MD5			:= $(call remove_quotes,$(PTXCONF_CROSS_LLVM_MD5))
CROSS_LLVM			:= llvm-$(CROSS_LLVM_VERSION)
CROSS_LLVM_SUFFIX		:= src.tar.xz
CROSS_LLVM_URL			:= \
	https://releases.llvm.org/$(CROSS_LLVM_VERSION)/$(CROSS_LLVM).$(CROSS_LLVM_SUFFIX) \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(CROSS_LLVM_VERSION)/$(CROSS_LLVM).$(CROSS_LLVM_SUFFIX)
CROSS_LLVM_SOURCE		:= $(SRCDIR)/$(CROSS_LLVM).$(CROSS_LLVM_SUFFIX)
CROSS_LLVM_DIR			:= $(CROSS_BUILDDIR)/$(CROSS_LLVM)
CROSS_LLVM_LICENSE		:= $(call remove_quotes,$(PTXCONF_CROSS_LLVM_LICENSE))
CROSS_LLVM_LICENSE_FILES	:= $(call remove_quotes,$(PTXCONF_CROSS_LLVM_LICENSE_FILES))

CROSS_LLVM_CMAKE_MODULES_VERSION	:= $(CROSS_LLVM_VERSION)
CROSS_LLVM_CMAKE_MODULES_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_LLVM_CMAKE_MODULES_MD5))
CROSS_LLVM_CMAKE_MODULES		:= cmake-$(CROSS_LLVM_CMAKE_MODULES_VERSION)
CROSS_LLVM_CMAKE_MODULES_SUFFIX		:= src.tar.xz
CROSS_LLVM_CMAKE_MODULES_URL		:= \
	https://releases.llvm.org/$(CROSS_LLVM_CMAKE_MODULES_VERSION)/$(CROSS_LLVM_CMAKE_MODULES).$(CROSS_LLVM_CMAKE_MODULES_SUFFIX) \
	https://github.com/llvm/llvm-project/releases/download/llvmorg-$(CROSS_LLVM_CMAKE_MODULES_VERSION)/$(CROSS_LLVM_CMAKE_MODULES).$(CROSS_LLVM_CMAKE_MODULES_SUFFIX)
CROSS_LLVM_CMAKE_MODULES_SOURCE		:= $(SRCDIR)/$(CROSS_LLVM_CMAKE_MODULES).$(CROSS_LLVM_SUFFIX)
CROSS_LLVM_CMAKE_MODULES_DIR		:= $(CROSS_BUILDDIR)/cmake
CROSS_LLVM_CMAKE_MODULES_STRIP_LEVEL	:= 1
$(CROSS_LLVM_CMAKE_MODULES_SOURCE)	:= CROSS_LLVM_CMAKE_MODULES
CROSS_LLVM_SOURCES			+= $(CROSS_LLVM_CMAKE_MODULES_SOURCE)

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CROSS_LLVM_HOST_ARCH	:= X86

ifdef PTXCONF_ARCH_ARM
CROSS_LLVM_TARGET_ARCH	:= ARM
endif
ifdef PTXCONF_ARCH_ARM64
CROSS_LLVM_TARGET_ARCH	:= AArch64
endif
ifdef PTXCONF_ARCH_X86_64
CROSS_LLVM_TARGET_ARCH	:= X86
endif
ifdef PTXCONF_ARCH_I386
CROSS_LLVM_TARGET_ARCH	:= X86
endif
ifdef PTXCONF_ARCH_MIPS
CROSS_LLVM_TARGET_ARCH	:= Mips
endif
ifdef PTXCONF_ARCH_MIPS64
CROSS_LLVM_TARGET_ARCH	:= Mips
endif
ifdef PTXCONF_ARCH_POWERPC
CROSS_LLVM_TARGET_ARCH	:= PowerPC
endif

ifdef PTXCONF_CROSS_LLVM
ifndef CROSS_LLVM_TARGET_ARCH
$(error Unsupported LLVM architecture $(PTXCONF_ARCH))
endif
endif

CROSS_LLVM_TARGETS_TO_BUILD := \
	$(CROSS_LLVM_HOST_ARCH) \
	$(CROSS_LLVM_TARGET_ARCH) \
	BPF

#
# cmake
#
CROSS_LLVM_CONF_TOOL	:= cmake
CROSS_LLVM_CONF_OPT	:= \
	$(HOST_CROSS_CMAKE_OPT) \
	-G Ninja \
	-DCMAKE_INSTALL_PREFIX=$(PTXCONF_PREFIX_CROSS) \
	-DLLVM_ENABLE_BINDINGS=OFF \
	-DLLVM_ENABLE_FFI=OFF \
	-DLLVM_ENABLE_LIBEDIT=OFF \
	-DLLVM_ENABLE_LIBPFM=OFF \
	-DLLVM_ENABLE_LIBXML2=OFF \
	-DLLVM_ENABLE_RTTI=ON \
	-DLLVM_INCLUDE_BENCHMARKS=OFF \
	-DLLVM_INCLUDE_TESTS=OFF \
	-DLLVM_INSTALL_TOOLCHAIN_ONLY=ON \
	-DLLVM_INSTALL_UTILS=OFF \
	-DLLVM_LINK_LLVM_DYLIB=ON \
	-DLLVM_TARGETS_TO_BUILD="$(subst $(space),;,$(CROSS_LLVM_TARGETS_TO_BUILD))" \
	-DLLVM_TARGET_ARCH=host \
	-DLLVM_USE_PERF=ON

CROSS_LLVM_LDFLAGS	:= \
	-Wl,-rpath,$$ORIGIN/../lib

$(STATEDIR)/cross-llvm.extract:
	@$(call targetinfo)
	@$(call clean, $(CROSS_LLVM_DIR))
	@$(call extract, CROSS_LLVM)
	@$(call extract, CROSS_LLVM_CMAKE_MODULES)
	@$(call touch)

$(STATEDIR)/cross-llvm.install:
	@$(call targetinfo)
	@$(call world/install, CROSS_LLVM)
	@install -v -m644 -D -t $(CROSS_LLVM_PKGDIR)/usr/lib/cmake/llvm \
		$(CROSS_LLVM_DIR)-build/lib/cmake/llvm/*
	@$(call touch)

# vim: syntax=make
