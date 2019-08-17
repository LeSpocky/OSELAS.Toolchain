# -*-makefile-*-
#
# Copyright (C) 2006 by Robert Schwebel
#
# See CREDITS for details about who has contributed to this project.
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
CROSS_PACKAGES-$(PTXCONF_CROSS_TOOLCHAIN) += cross-toolchain

CROSS_TOOLCHAIN_LICENSE := ignore

# ----------------------------------------------------------------------------
# Install
# ----------------------------------------------------------------------------

CROSS_TOOLCHAIN_PTXCONFIG := \
	$(PTXDIST_SYSROOT_CROSS)$(PTXCONF_PREFIX_CROSS)/bin/ptxconfig

$(STATEDIR)/cross-toolchain.install:
	@$(call targetinfo)
	@install -vD -m644 $(PTXDIST_PTXCONFIG) $(CROSS_TOOLCHAIN_PTXCONFIG)
	@$(call touch)

# vim: syntax=make
