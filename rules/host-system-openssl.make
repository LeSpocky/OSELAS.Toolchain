# -*-makefile-*-
#
# Copyright (C) 2021 by Michael Olbrich <m.olbrich@pengutronix.de>
#
# For further information about the PTXdist project and license conditions
# see the README file.
#

#
# We provide this package
#
HOST_PACKAGES-$(PTXCONF_HOST_SYSTEM_OPENSSL) += host-system-openssl
HOST_SYSTEM_OPENSSL_LICENSE	:= ignore

# ----------------------------------------------------------------------------
# Prepare
# ----------------------------------------------------------------------------

$(STATEDIR)/host-system-openssl.prepare:
	@$(call targetinfo)
	@echo "Checking for openssl ..."
	@pkg-config openssl || \
		ptxd_bailout "openssl development files not found!" \
		"Please install libssl-dev (debian) or openssl-devel (fedora)"
	@$(call touch)

# vim: syntax=make
