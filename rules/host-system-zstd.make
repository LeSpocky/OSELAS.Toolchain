# -*-makefile-*-
#
# Copyright (C) 2024 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_ZSTD) += host-system-zstd
HOST_SYSTEM_ZSTD_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-zstd.prepare:
	@$(call targetinfo)
	@echo "Checking for libzstd ..."
	@pkg-config libzstd || \
		ptxd_bailout "zstd development files not found!" \
		"Please install libzstd-dev (debian) or libzstd-devel (fedora)"
	@$(call touch)

# vim: syntax=make
