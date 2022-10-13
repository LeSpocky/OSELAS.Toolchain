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
CROSS_PACKAGES-$(PTXCONF_CROSS_RUSTC) += cross-rustc

#
# Paths and names
#
CROSS_RUSTC_VERSION	:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_VERSION))
CROSS_RUSTC_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_MD5))
CROSS_RUSTC		:= rustc-$(CROSS_RUSTC_VERSION)
CROSS_RUSTC_SUFFIX	:= tar.xz
CROSS_RUSTC_URL		:= https://static.rust-lang.org/dist/$(CROSS_RUSTC)-src.$(CROSS_RUSTC_SUFFIX)
CROSS_RUSTC_SOURCE	:= $(SRCDIR)/$(CROSS_RUSTC)-src.$(CROSS_RUSTC_SUFFIX)
CROSS_RUSTC_DIR		:= $(CROSS_BUILDDIR)/$(CROSS_RUSTC)

CROSS_RUSTC_BUILD_VERSION		:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_BUILD_VERSION))
CROSS_RUSTC_BUILD_DATE			:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_BUILD_DATE))

CROSS_RUSTC_BUILD_STD_VERSION		:= $(CROSS_RUSTC_BUILD_VERSION)
CROSS_RUSTC_BUILD_STD_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_BUILD_STD_MD5))
CROSS_RUSTC_BUILD_STD			:= rust-std-$(CROSS_RUSTC_BUILD_STD_VERSION)-$(GNU_BUILD)
CROSS_RUSTC_BUILD_STD_SUFFIX		:= tar.xz
CROSS_RUSTC_BUILD_STD_URL		:= https://static.rust-lang.org/dist/$(CROSS_RUSTC_BUILD_DATE)/$(CROSS_RUSTC_BUILD_STD).$(CROSS_RUSTC_BUILD_STD_SUFFIX)
CROSS_RUSTC_BUILD_STD_SOURCE		:= $(SRCDIR)/$(CROSS_RUSTC_BUILD_STD).$(CROSS_RUSTC_BUILD_STD_SUFFIX)
$(CROSS_RUSTC_BUILD_STD_SOURCE)		:= CROSS_RUSTC_BUILD_STD
CROSS_RUSTC_SOURCES			+= $(CROSS_RUSTC_BUILD_STD_SOURCE)

CROSS_RUSTC_BUILD_RUSTC_VERSION		:= $(CROSS_RUSTC_BUILD_VERSION)
CROSS_RUSTC_BUILD_RUSTC_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_BUILD_RUSTC_MD5))
CROSS_RUSTC_BUILD_RUSTC			:= rustc-$(CROSS_RUSTC_BUILD_RUSTC_VERSION)-$(GNU_BUILD)
CROSS_RUSTC_BUILD_RUSTC_SUFFIX		:= tar.xz
CROSS_RUSTC_BUILD_RUSTC_URL		:= https://static.rust-lang.org/dist/$(CROSS_RUSTC_BUILD_DATE)/$(CROSS_RUSTC_BUILD_RUSTC).$(CROSS_RUSTC_BUILD_RUSTC_SUFFIX)
CROSS_RUSTC_BUILD_RUSTC_SOURCE		:= $(SRCDIR)/$(CROSS_RUSTC_BUILD_RUSTC).$(CROSS_RUSTC_BUILD_RUSTC_SUFFIX)
$(CROSS_RUSTC_BUILD_RUSTC_SOURCE)	:= CROSS_RUSTC_BUILD_RUSTC
CROSS_RUSTC_SOURCES			+= $(CROSS_RUSTC_BUILD_RUSTC_SOURCE)

CROSS_RUSTC_BUILD_CARGO_VERSION		:= $(CROSS_RUSTC_BUILD_VERSION)
CROSS_RUSTC_BUILD_CARGO_MD5		:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_BUILD_CARGO_MD5))
CROSS_RUSTC_BUILD_CARGO			:= cargo-$(CROSS_RUSTC_BUILD_CARGO_VERSION)-$(GNU_BUILD)
CROSS_RUSTC_BUILD_CARGO_SUFFIX		:= tar.xz
CROSS_RUSTC_BUILD_CARGO_URL		:= https://static.rust-lang.org/dist/$(CROSS_RUSTC_BUILD_DATE)/$(CROSS_RUSTC_BUILD_CARGO).$(CROSS_RUSTC_BUILD_CARGO_SUFFIX)
CROSS_RUSTC_BUILD_CARGO_SOURCE		:= $(SRCDIR)/$(CROSS_RUSTC_BUILD_CARGO).$(CROSS_RUSTC_BUILD_CARGO_SUFFIX)
$(CROSS_RUSTC_BUILD_CARGO_SOURCE)	:= CROSS_RUSTC_BUILD_CARGO
CROSS_RUSTC_SOURCES			+= $(CROSS_RUSTC_BUILD_CARGO_SOURCE)

CROSS_RUSTC_CONFIG	:= $(call ptx/in-path, PTXDIST_PATH_LAYERS, config/rustc.toml)
CROSS_RUSTC_TARGET	:= $(call remove_quotes,$(PTXCONF_CROSS_RUSTC_TARGET))
CROSS_RUSTC_TARGET_PATH	:= $(PTXDIST_WORKSPACE)/config/rust

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

CROSS_RUSTC_CONF_ENV	:= \
	BUILD_TRIPLE=$(GNU_BUILD) \
	TARGET_TRIPLE=$(CROSS_RUSTC_TARGET) \
	PREFIX=$(PTXCONF_PREFIX_CROSS) \
	LLVM_CONFIG=$(CROSS_LLVM_DIR)-build/bin/llvm-config \
	COMPILER_PREFIX=$(COMPILER_PREFIX)

$(STATEDIR)/cross-rustc.prepare:
	@$(call targetinfo)
	@mkdir -p $(CROSS_RUSTC_DIR)/build/cache/$(CROSS_RUSTC_BUILD_DATE)
	@cp -v \
		$(CROSS_RUSTC_BUILD_STD_SOURCE) \
		$(CROSS_RUSTC_BUILD_RUSTC_SOURCE) \
		$(CROSS_RUSTC_BUILD_CARGO_SOURCE) \
		$(CROSS_RUSTC_DIR)/build/cache/$(CROSS_RUSTC_BUILD_DATE)/
	$(CROSS_RUSTC_CONF_ENV) ptxd_replace_magic \
		$(CROSS_RUSTC_CONFIG) > $(CROSS_RUSTC_DIR)/config.toml
	@$(call touch)

# ----------------------------------------------------------------------------
# Compile
# ----------------------------------------------------------------------------

CROSS_RUSTC_MAKE_ENV	:= \
	RUST_TARGET_PATH=$(CROSS_RUSTC_TARGET_PATH)

$(STATEDIR)/cross-rustc.compile:
	@$(call targetinfo)
	@$(call world/execute, CROSS_RUSTC, ./x.py build)
	@$(call touch)

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

define ptx/cross-rustc-wrapper-impl
echo "Creating '$(1)'..."
rm -f '$(1)'
echo '#!/bin/sh' > '$(1)'
echo 'd="$$(dirname $$(readlink -f "$${0}"))"' >> '$(1)'
echo 'export RUST_TARGET_PATH="$$d"' >> '$(1)'
echo 'exec "$$d/rustc" --target $(CROSS_RUSTC_TARGET) "$$@"' >> '$(1)'
chmod +x '$(1)'
endef

define ptx/cross-rustc-wrapper
$(call ptx/cross-rustc-wrapper-impl,$(strip \
	$(CROSS_RUSTC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/$(COMPILER_PREFIX)rustc))
endef

$(STATEDIR)/cross-rustc.install:
	@$(call targetinfo)
	@$(call world/execute, CROSS_RUSTC, \
		DESTDIR=$(CROSS_RUSTC_PKGDIR) ./x.py install)
	@cp -v $(CROSS_RUSTC_TARGET_PATH)/$(CROSS_RUSTC_TARGET).json \
		$(CROSS_RUSTC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/bin/
	@$(call ptx/cross-rustc-wrapper)
	@rm -v $(CROSS_RUSTC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/lib/rustlib/install.log
ifneq ($(call remove_quotes,$(PTXDIST_SYSROOT_CROSS)),)
	sed -i -e 's;$(PTXDIST_WORKSPACE);OSELAS.Toolchain;' \
		$(CROSS_RUSTC_PKGDIR)$(PTXCONF_PREFIX_CROSS)/lib/rustlib/manifest*
endif
	@$(call touch)

# vim: syntax=make
