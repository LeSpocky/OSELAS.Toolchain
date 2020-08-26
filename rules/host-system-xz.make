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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_XZ) += host-system-xz
HOST_SYSTEM_XZ_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-xz.prepare:
	@$(call targetinfo)
	@echo "Checking for expat ..."
	@pkg-config liblzma || \
		ptxd_bailout "xz (lzma) development files not found!" \
		"Please install liblzma-dev (debian)"
	@$(call touch)

# vim: syntax=make
