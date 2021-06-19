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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_ZLIB) += host-system-zlib
HOST_SYSTEM_ZLIB_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-zlib.prepare:
	@$(call targetinfo)
	@echo "Checking for zlib ..."
	@pkg-config zlib || \
		ptxd_bailout "zlib development files not found!" \
		"Please install zlib1g-dev (debian) or zlib-devel (fedora)"
	@$(call touch)

# vim: syntax=make
