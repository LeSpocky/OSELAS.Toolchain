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
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_EXPAT) += host-system-expat
HOST_SYSTEM_EXPAT_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-expat.prepare:
	@$(call targetinfo)
	@echo "Checking for expat ..."
	@pkg-config expat || \
		ptxd_bailout "expat development files not found!" \
		"Please install libexpat1-dev (debian) or expat-devel (fedora)"
	@$(call touch)

# vim: syntax=make
